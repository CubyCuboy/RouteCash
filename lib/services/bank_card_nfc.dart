import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';
import '../models/card_model.dart';
import '../utils/bank_utils.dart';

class BankCardNfcResult {
  const BankCardNfcResult({
    required this.status,
    this.brand,
    this.type,
    this.bankName,
    this.cardNumber,
    this.expiryDate,
    this.cardholderName,
    this.message = '',
  });

  final bool status;
  final String? brand;
  final RouteCashCardType? type;
  final String? bankName;
  final String? cardNumber;
  final String? expiryDate;
  final String? cardholderName;
  final String message;
}

class BankCardNfcService {
  Completer<BankCardNfcResult>? _completer;
  bool _sessionActive = false;
  
  final _statusController = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusController.stream;

  static final Uint8List _selectPpseCommand = Uint8List.fromList([
    0x00, 0xA4, 0x04, 0x00, 0x0E, 0x32, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0x00
  ]);

  Future<BankCardNfcResult> readPaymentCard() async {
    if (_sessionActive) {
      return const BankCardNfcResult(status: false, message: 'nfcErrorSessionActive');
    }

    final availability = await NfcManager.instance.checkAvailability();
    if (availability != NfcAvailability.enabled) {
      return const BankCardNfcResult(status: false, message: 'nfcErrorAvailability');
    }

    _sessionActive = true;
    _completer = Completer<BankCardNfcResult>();
    _statusController.add('nfcStatusIdle');

    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (tag) async {
        try {
          _statusController.add('nfcStatusDetected');
          
          final ppseResponse = await _transceive(tag, _selectPpseCommand);
          if (ppseResponse == null) throw 'nfcErrorPpse';
          
          final ppseHex = _toHex(ppseResponse);
          if (!ppseHex.endsWith('9000')) throw 'nfcErrorIncompatible';

          final aid = _findKnownAid(ppseHex);
          if (aid == null) throw 'nfcErrorNoAid';

          _statusController.add('nfcStatusReadingConfig');
          final aidBytes = _hexToBytes(aid);
          final selectAidCommand = Uint8List.fromList([
            0x00, 0xA4, 0x04, 0x00, aidBytes.length, ...aidBytes, 0x00
          ]);
          final aidResponse = await _transceive(tag, selectAidCommand);
          if (aidResponse == null || !_toHex(aidResponse).endsWith('9000')) {
            throw 'nfcErrorAidAccess';
          }

          String? pan;
          String? expiry;
          String? holder;

          _statusController.add('nfcStatusRetrievingData');
          
          for (int sfi = 1; sfi <= 3; sfi++) {
            for (int record = 1; record <= 5; record++) {
              final readRecordCommand = Uint8List.fromList([0x00, 0xB2, record, (sfi << 3) | 4, 0x00]);
              final response = await _transceive(tag, readRecordCommand);
              if (response != null) {
                final hex = _toHex(response);
                if (hex.endsWith('9000')) {
                  pan ??= _findTag(hex, '5A');
                  expiry ??= _findTag(hex, '5F24');
                  holder ??= _findTag(hex, '5F20');
                }
              }
              if (pan != null && expiry != null) break;
            }
            if (pan != null && expiry != null) break;
          }
          
          if (pan == null) throw 'nfcErrorRetrieveFail';

          final cardDetails = BankUtils.identifyCard(pan);

          final result = BankCardNfcResult(
            status: true,
            brand: cardDetails.brand,
            type: cardDetails.type,
            bankName: cardDetails.bankName,
            cardNumber: pan,
            expiryDate: _formatExpiry(expiry),
            cardholderName: holder != null ? _hexToString(holder) : null,
            message: 'nfcStatusSuccess',
          );

          if (!(_completer?.isCompleted ?? true)) _completer!.complete(result);
        } catch (e) {
          debugPrint('NFC Error: $e');
          _statusController.add(e.toString());
          if (!(_completer?.isCompleted ?? true)) {
            _completer!.complete(BankCardNfcResult(status: false, message: e.toString()));
          }
        } finally {
          await stopReading();
        }
      },
    );
    try {
      return await _completer!.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          stopReading();
          return const BankCardNfcResult(status: false, message: 'nfcTimeout');
        },
      );
    } catch (e) {
      return BankCardNfcResult(status: false, message: e.toString());
    }
  }

  Future<Uint8List?> _transceive(NfcTag tag, Uint8List command) async {
    try {
      if (Platform.isAndroid) {
        final isoDep = IsoDepAndroid.from(tag);
        return await isoDep?.transceive(command);
      } else if (Platform.isIOS) {
        final iso7816 = Iso7816Ios.from(tag);
        final res = await iso7816?.sendCommand(
          instructionClass: command[0],
          instructionCode: command[1],
          p1Parameter: command[2],
          p2Parameter: command[3],
          data: command.length > 5 ? command.sublist(5, command.length - 1) : Uint8List(0),
          expectedResponseLength: command.last,
        );
        if (res == null) return null;
        return Uint8List.fromList([...res.payload, res.statusWord1, res.statusWord2]);
      }
    } catch (e) {
      debugPrint('Transceive error: $e');
    }
    return null;
  }

  Future<void> stopReading() async {
    _sessionActive = false;
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
  }

  String _toHex(Uint8List bytes) => bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join().toUpperCase();

  Uint8List _hexToBytes(String hex) {
    final bytes = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < hex.length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return bytes;
  }

  String _hexToString(String hex) {
    try {
      final bytes = _hexToBytes(hex);
      return String.fromCharCodes(bytes).trim();
    } catch (_) {
      return hex;
    }
  }

  String? _findTag(String data, String tag) {
    int index = data.indexOf(tag);
    if (index == -1) return null;
    try {
      int lenStart = index + tag.length;
      int length = int.parse(data.substring(lenStart, lenStart + 2), radix: 16);
      String value = data.substring(lenStart + 2, lenStart + 2 + (length * 2));
      
      if (tag == '5A' && value.endsWith('F')) {
        value = value.substring(0, value.length - 1);
      }
      return value;
    } catch (_) {
      return null;
    }
  }

  String? _formatExpiry(String? expiry) {
    if (expiry == null || expiry.length < 4) return null;
    try {
      return '${expiry.substring(2, 4)}/${expiry.substring(0, 2)}';
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

  void dispose() {
    _statusController.close();
  }
}
