import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';

class BankCardNfcResult {
  const BankCardNfcResult({
    required this.detected,
    required this.message,
    this.brand,
    this.applicationId,
    this.cardNumber,
    this.expiryDate,
  });

  final bool detected;
  final String message;
  final String? brand;
  final String? applicationId;
  final String? cardNumber;
  final String? expiryDate;
}

class BankCardNfcService {
  Completer<BankCardNfcResult>? _completer;
  bool _sessionActive = false;

  static final Uint8List _selectPpseCommand = Uint8List.fromList([
    0x00, 0xA4, 0x04, 0x00, 0x0E, 0x32, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0x00
  ]);

  Future<BankCardNfcResult> readPaymentCard() async {
    if (_sessionActive) {
      throw Exception('Ya existe una lectura NFC en curso.');
    }

    final availability = await NfcManager.instance.checkAvailability();
    if (availability != NfcAvailability.enabled) {
      throw Exception('NFC no está disponible o está desactivado.');
    }

    _sessionActive = true;
    _completer = Completer<BankCardNfcResult>();

    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (tag) async {
        try {
          // 1. Select PPSE
          final ppseResponse = await _transceive(tag, _selectPpseCommand);
          if (ppseResponse == null) throw Exception('La tarjeta no respondió al comando inicial.');
          
          final ppseHex = _toHex(ppseResponse);
          if (!ppseHex.endsWith('9000')) throw Exception('Tarjeta no compatible con el estándar de pago.');

          // 2. Find AID
          final aid = _findKnownAid(ppseHex);
          if (aid == null) throw Exception('No se encontró una aplicación de pago (Visa/Mastercard) compatible.');

          // 3. Select Application (AID)
          final aidBytes = _hexToBytes(aid);
          final selectAidCommand = Uint8List.fromList([
            0x00, 0xA4, 0x04, 0x00, aidBytes.length, ...aidBytes, 0x00
          ]);
          final aidResponse = await _transceive(tag, selectAidCommand);
          if (aidResponse == null) throw Exception('Error al seleccionar la aplicación de la tarjeta.');
          
          final aidHex = _toHex(aidResponse);
          if (!aidHex.endsWith('9000')) throw Exception('La tarjeta rechazó la selección de aplicación.');

          // 4. Try reading records to find PAN (Card Number) and Expiry
          String? pan;
          String? expiry;

          for (int sfi = 1; sfi <= 5; sfi++) {
            for (int record = 1; record <= 10; record++) {
              final readRecordCommand = Uint8List.fromList([
                0x00, 0xB2, record, (sfi << 3) | 4, 0x00
              ]);
              try {
                final recordResponse = await _transceive(tag, readRecordCommand);
                if (recordResponse != null) {
                  final recordHex = _toHex(recordResponse);
                  if (recordHex.endsWith('9000')) {
                    pan ??= _findTag(recordHex, '5A');
                    expiry ??= _findTag(recordHex, '5F24');
                  }
                }
              } catch (_) {}
              if (pan != null && expiry != null) break;
            }
            if (pan != null && expiry != null) break;
          }

          final brand = _detectBrand(aid);
          
          final result = BankCardNfcResult(
            detected: true,
            brand: brand,
            applicationId: aid,
            cardNumber: pan,
            expiryDate: _formatExpiry(expiry),
            message: brand == null 
              ? 'Tarjeta detectada correctamente.' 
              : 'Tarjeta $brand detectada.',
          );

          if (!(_completer?.isCompleted ?? true)) {
            _completer!.complete(result);
          }
        } catch (error) {
          debugPrint('NFC Service Error: $error');
          if (!(_completer?.isCompleted ?? true)) {
            _completer!.completeError(error);
          }
        } finally {
          await stopReading();
        }
      },
    );

    try {
      return await _completer!.future.timeout(const Duration(seconds: 25));
    } on TimeoutException {
      throw Exception('Tiempo agotado. Por favor acerca la tarjeta nuevamente.');
    } finally {
      await stopReading();
    }
  }

  Future<Uint8List?> _transceive(NfcTag tag, Uint8List command) async {
    if (Platform.isAndroid) {
      final isoDep = IsoDepAndroid.from(tag);
      if (isoDep == null) return null;
      try {
        return await isoDep.transceive(command);
      } catch (e) {
        debugPrint('Android Transceive Error: $e');
        return null;
      }
    } else if (Platform.isIOS) {
      final iso7816 = Iso7816Ios.from(tag);
      if (iso7816 == null) return null;
      try {
        final res = await iso7816.sendCommand(
          instructionClass: command[0],
          instructionCode: command[1],
          p1Parameter: command[2],
          p2Parameter: command[3],
          data: command.length > 5 ? command.sublist(5, command.length - 1) : Uint8List(0),
          expectedResponseLength: command.last,
        );
        
        final fullResponse = Uint8List(res.payload.length + 2);
        fullResponse.setAll(0, res.payload);
        fullResponse[res.payload.length] = res.statusWord1;
        fullResponse[res.payload.length + 1] = res.statusWord2;
        return fullResponse;
      } catch (e) {
        debugPrint('iOS Transceive Error: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> stopReading() async {
    if (!_sessionActive) return;
    _sessionActive = false;
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
  }

  String _toHex(Uint8List bytes) =>
      bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join().toUpperCase();

  Uint8List _hexToBytes(String hex) {
    final bytes = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < hex.length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return bytes;
  }

  String? _findTag(String data, String tag) {
    int index = data.indexOf(tag);
    if (index == -1) return null;

    try {
      int lenIndex = index + tag.length;
      int length = int.parse(data.substring(lenIndex, lenIndex + 2), radix: 16);
      String value = data.substring(lenIndex + 2, lenIndex + 2 + (length * 2));
      
      if (tag == '5A') {
        if (value.endsWith('F')) value = value.substring(0, value.length - 1);
      }
      return value;
    } catch (_) {
      return null;
    }
  }

  String? _formatExpiry(String? expiry) {
    if (expiry == null || expiry.length < 4) return null;
    try {
      final year = expiry.substring(0, 2);
      final month = expiry.substring(2, 4);
      return '$month/$year';
    } catch (_) {
      return null;
    }
  }

  String? _findKnownAid(String payload) {
    final aids = ['A000000003', 'A000000004', 'A000000025', 'A000000065', 'A000000152'];
    for (final aid in aids) {
      if (payload.contains(aid)) {
        int start = payload.indexOf(aid);
        return payload.substring(start, start + 14);
      }
    }
    return null;
  }

  String? _detectBrand(String aid) {
    if (aid.startsWith('A000000003')) return 'Visa';
    if (aid.startsWith('A000000004')) return 'Mastercard';
    if (aid.startsWith('A000000025')) return 'American Express';
    if (aid.startsWith('A000000065')) return 'JCB';
    if (aid.startsWith('A000000152')) return 'Discover';
    return null;
  }
}
