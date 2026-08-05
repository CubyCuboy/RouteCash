import 'dart:async';
import 'dart:typed_data';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

class BankCardNfcResult {
  const BankCardNfcResult({
    required this.detected,
    required this.message,
    this.brand,
    this.applicationId,
  });

  final bool detected;
  final String message;
  final String? brand;
  final String? applicationId;
}

class BankCardNfcService {
  Completer<BankCardNfcResult>? _completer;
  bool _sessionActive = false;

  static final Uint8List _selectPpseCommand = Uint8List.fromList(
    <int>[
      0x00, 0xA4, 0x04, 0x00, 0x0E,
      0x32, 0x50, 0x41, 0x59, 0x2E,
      0x53, 0x59, 0x53, 0x2E, 0x44,
      0x44, 0x46, 0x30, 0x31, 0x00,
    ],
  );

  Future<BankCardNfcResult> readPaymentCard() async {
    if (_sessionActive) {
      throw Exception('Ya existe una lectura NFC en curso.');
    }

    final availability = await NfcManager.instance.checkAvailability();

    if (availability != NfcAvailability.enabled) {
      throw Exception(
        'NFC no está disponible o está desactivado en este dispositivo.',
      );
    }

    _sessionActive = true;
    _completer = Completer<BankCardNfcResult>();

    await NfcManager.instance.startSession(
      pollingOptions: const {
        NfcPollingOption.iso14443,
      },
      onDiscovered: (tag) async {
        try {
          final isoDep = IsoDepAndroid.from(tag);

          if (isoDep == null) {
            throw Exception(
              'La tarjeta detectada no es compatible con ISO-DEP.',
            );
          }

          await isoDep.setTimeout(5000);

          final response = await isoDep.transceive(
            _selectPpseCommand,
          );

          final hex = _toHex(response);

          if (!hex.endsWith('9000')) {
            throw Exception(
              'Se detectó una tarjeta NFC, pero no respondió como tarjeta EMV.',
            );
          }

          final aid = _findKnownAid(hex);
          final brand = _detectBrand(aid ?? hex);

          final result = BankCardNfcResult(
            detected: true,
            brand: brand,
            applicationId: aid,
            message: brand == null
                ? 'Tarjeta contactless detectada. La red no pudo identificarse.'
                : 'Tarjeta $brand detectada correctamente.',
          );

          if (!(_completer?.isCompleted ?? true)) {
            _completer!.complete(result);
          }
        } catch (error) {
          if (!(_completer?.isCompleted ?? true)) {
            _completer!.completeError(error);
          }
        } finally {
          await stopReading();
        }
      },
    );

    try {
      return await _completer!.future.timeout(
        const Duration(seconds: 30),
      );
    } on TimeoutException {
      throw Exception(
        'No se detectó una tarjeta dentro del tiempo permitido.',
      );
    } finally {
      await stopReading();
    }
  }

  Future<void> stopReading() async {
    if (!_sessionActive) return;

    _sessionActive = false;

    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
  }

  String _toHex(Uint8List bytes) {
    return bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }

  String? _findKnownAid(String payload) {
    const prefixes = <String>[
      'A000000003',
      'A000000004',
      'A000000025',
      'A000000065',
      'A000000152',
    ];

    for (final prefix in prefixes) {
      final index = payload.indexOf(prefix);

      if (index >= 0) {
        final remaining = payload.substring(index);
        final length = remaining.length >= 16 ? 16 : remaining.length;
        return remaining.substring(0, length);
      }
    }

    return null;
  }

  String? _detectBrand(String payload) {
    if (payload.contains('A000000003')) return 'Visa';
    if (payload.contains('A000000004')) return 'Mastercard';
    if (payload.contains('A000000025')) return 'American Express';
    if (payload.contains('A000000065')) return 'JCB';
    if (payload.contains('A000000152')) return 'Discover';
    return null;
  }
}
