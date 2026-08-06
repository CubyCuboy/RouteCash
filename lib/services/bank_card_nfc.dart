import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

class BankCardNfcResult {
  const BankCardNfcResult({
    required this.detected,
    required this.message,
    this.brand,
    this.applicationId,
    this.lastFourDigits,
  });

  final bool detected;
  final String message;
  final String? brand;
  final String? applicationId;

  /// Solo contiene los últimos cuatro dígitos.
  ///
  /// El PAN completo nunca se devuelve desde este servicio.
  final String? lastFourDigits;
}

class BankCardNfcService {
  Completer<BankCardNfcResult>? _completer;
  bool _sessionActive = false;

  static final Uint8List _selectPpseCommand = Uint8List.fromList(
    <int>[
      0x00,
      0xA4,
      0x04,
      0x00,
      0x0E,
      0x32,
      0x50,
      0x41,
      0x59,
      0x2E,
      0x53,
      0x59,
      0x53,
      0x2E,
      0x44,
      0x44,
      0x46,
      0x30,
      0x31,
      0x00,
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

          final result = await _readEmvCard(isoDep);

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

  Future<BankCardNfcResult> _readEmvCard(
    IsoDepAndroid isoDep,
  ) async {
    final ppseResponse = await _transceive(
      isoDep,
      _selectPpseCommand,
    );

    if (!_isSuccess(ppseResponse)) {
      throw Exception(
        'Se detectó una tarjeta NFC, pero no respondió como tarjeta EMV. '
        'Código: ${_statusWord(ppseResponse)}.',
      );
    }

    final ppseData = _removeStatusWord(ppseResponse);
    final applicationIds = _findAllTagValues(
      ppseData,
      0x4F,
    );

    if (applicationIds.isEmpty) {
      throw Exception(
        'La tarjeta respondió como EMV, pero no informó aplicaciones de pago.',
      );
    }

    String? detectedBrand;
    String? detectedAid;
    String? lastFourDigits;

    for (final aidBytes in applicationIds) {
      if (aidBytes.isEmpty) {
        continue;
      }

      final aid = _toHex(aidBytes);
      final brand = _detectBrand(aid);

      detectedAid ??= aid;
      detectedBrand ??= brand;

      try {
        final result = await _readApplication(
          isoDep: isoDep,
          aid: aidBytes,
        );

        if (result != null) {
          detectedAid = aid;
          detectedBrand = brand;
          lastFourDigits = result;
          break;
        }
      } catch (_) {
        // Algunas tarjetas anuncian varias aplicaciones EMV.
        // Si una aplicación falla, se intenta con la siguiente.
      }
    }

    if (lastFourDigits != null) {
      return BankCardNfcResult(
        detected: true,
        brand: detectedBrand,
        applicationId: detectedAid,
        lastFourDigits: lastFourDigits,
        message: detectedBrand == null
            ? 'Tarjeta detectada. Se obtuvieron los últimos 4 dígitos.'
            : 'Tarjeta $detectedBrand detectada. '
                  'Se obtuvieron los últimos 4 dígitos.',
      );
    }

    return BankCardNfcResult(
      detected: true,
      brand: detectedBrand,
      applicationId: detectedAid,
      lastFourDigits: null,
      message: detectedBrand == null
          ? 'Tarjeta contactless detectada, pero no entregó '
                'los últimos 4 dígitos.'
          : 'Tarjeta $detectedBrand detectada, pero no entregó '
                'los últimos 4 dígitos.',
    );
  }

  Future<String?> _readApplication({
    required IsoDepAndroid isoDep,
    required Uint8List aid,
  }) async {
    final selectResponse = await _transceive(
      isoDep,
      _buildSelectApplicationCommand(aid),
    );

    if (!_isSuccess(selectResponse)) {
      return null;
    }

    final selectData = _removeStatusWord(selectResponse);

    /*
     * En algunas tarjetas el PAN puede venir dentro de la respuesta
     * SELECT. Se procesa, se obtienen los últimos cuatro dígitos
     * y se descarta el valor completo.
     */
    final panFromSelect = _extractLastFourDigits(selectData);

    if (panFromSelect != null) {
      return panFromSelect;
    }

    final pdolValues = _findAllTagValues(
      selectData,
      0x9F38,
    );

    final pdol = pdolValues.isNotEmpty
        ? pdolValues.first
        : Uint8List(0);

    final gpoResponse = await _transceive(
      isoDep,
      _buildGetProcessingOptionsCommand(pdol),
    );

    if (!_isSuccess(gpoResponse)) {
      return null;
    }

    final gpoData = _removeStatusWord(gpoResponse);

    final panFromGpo = _extractLastFourDigits(gpoData);

    if (panFromGpo != null) {
      return panFromGpo;
    }

    final afl = _extractAfl(gpoData);

    if (afl == null || afl.isEmpty) {
      return null;
    }

    return _readAflRecords(
      isoDep: isoDep,
      afl: afl,
    );
  }

  Future<String?> _readAflRecords({
    required IsoDepAndroid isoDep,
    required Uint8List afl,
  }) async {
    /*
     * Cada entrada AFL ocupa cuatro bytes:
     *
     * Byte 1: SFI desplazado tres bits.
     * Byte 2: primer registro.
     * Byte 3: último registro.
     * Byte 4: registros para autenticación offline.
     */
    for (int offset = 0; offset + 3 < afl.length; offset += 4) {
      final sfi = afl[offset] >> 3;
      final firstRecord = afl[offset + 1];
      final lastRecord = afl[offset + 2];

      if (sfi < 1 || sfi > 30) {
        continue;
      }

      if (firstRecord < 1 || lastRecord < firstRecord) {
        continue;
      }

      for (
        int recordNumber = firstRecord;
        recordNumber <= lastRecord;
        recordNumber++
      ) {
        final command = _buildReadRecordCommand(
          sfi: sfi,
          recordNumber: recordNumber,
        );

        Uint8List response;

        try {
          response = await _transceive(
            isoDep,
            command,
          );
        } catch (_) {
          continue;
        }

        if (!_isSuccess(response)) {
          continue;
        }

        final recordData = _removeStatusWord(response);
        final lastFourDigits = _extractLastFourDigits(
          recordData,
        );

        if (lastFourDigits != null) {
          return lastFourDigits;
        }
      }
    }

    return null;
  }

  Uint8List _buildSelectApplicationCommand(
    Uint8List aid,
  ) {
    return Uint8List.fromList(
      <int>[
        0x00,
        0xA4,
        0x04,
        0x00,
        aid.length,
        ...aid,
        0x00,
      ],
    );
  }

  Uint8List _buildGetProcessingOptionsCommand(
    Uint8List pdol,
  ) {
    final pdolData = _buildPdolData(pdol);

    final commandData = Uint8List.fromList(
      <int>[
        0x83,
        pdolData.length,
        ...pdolData,
      ],
    );

    return Uint8List.fromList(
      <int>[
        0x80,
        0xA8,
        0x00,
        0x00,
        commandData.length,
        ...commandData,
        0x00,
      ],
    );
  }

  Uint8List _buildReadRecordCommand({
    required int sfi,
    required int recordNumber,
  }) {
    final p2 = (sfi << 3) | 0x04;

    return Uint8List.fromList(
      <int>[
        0x00,
        0xB2,
        recordNumber,
        p2,
        0x00,
      ],
    );
  }

  Uint8List _buildPdolData(
    Uint8List pdol,
  ) {
    if (pdol.isEmpty) {
      return Uint8List(0);
    }

    final output = <int>[];
    int offset = 0;

    while (offset < pdol.length) {
      final tagResult = _readTag(
        pdol,
        offset,
      );

      if (tagResult == null) {
        break;
      }

      final tag = tagResult.tag;
      offset = tagResult.nextOffset;

      if (offset >= pdol.length) {
        break;
      }

      final requestedLength = pdol[offset];
      offset++;

      output.addAll(
        _terminalValueForTag(
          tag: tag,
          requestedLength: requestedLength,
        ),
      );
    }

    return Uint8List.fromList(output);
  }

  List<int> _terminalValueForTag({
    required int tag,
    required int requestedLength,
  }) {
    List<int> value;

    switch (tag) {
      /*
       * 9F66: Terminal Transaction Qualifiers.
       */
      case 0x9F66:
        value = <int>[
          0x26,
          0x00,
          0x00,
          0x00,
        ];
        break;

      /*
       * 9F02: importe autorizado.
       */
      case 0x9F02:
        value = List<int>.filled(6, 0);
        break;

      /*
       * 9F03: importe adicional.
       */
      case 0x9F03:
        value = List<int>.filled(6, 0);
        break;

      /*
       * 9F1A: código de país del terminal.
       * 0152 corresponde a Chile en BCD.
       */
      case 0x9F1A:
        value = <int>[
          0x01,
          0x52,
        ];
        break;

      /*
       * 5F2A: código de moneda.
       * 0152 corresponde al peso chileno.
       */
      case 0x5F2A:
        value = <int>[
          0x01,
          0x52,
        ];
        break;

      /*
       * 95: Terminal Verification Results.
       */
      case 0x95:
        value = List<int>.filled(5, 0);
        break;

      /*
       * 9A: fecha YYMMDD.
       */
      case 0x9A:
        final now = DateTime.now();
        value = <int>[
          _decimalToBcd(now.year % 100),
          _decimalToBcd(now.month),
          _decimalToBcd(now.day),
        ];
        break;

      /*
       * 9C: tipo de transacción.
       * 00 corresponde normalmente a compra.
       */
      case 0x9C:
        value = <int>[0x00];
        break;

      /*
       * 9F37: número impredecible.
       */
      case 0x9F37:
        final random = Random.secure();
        value = List<int>.generate(
          4,
          (_) => random.nextInt(256),
        );
        break;

      default:
        value = List<int>.filled(
          requestedLength,
          0,
        );
        break;
    }

    if (value.length == requestedLength) {
      return value;
    }

    if (value.length > requestedLength) {
      return value.sublist(
        0,
        requestedLength,
      );
    }

    return <int>[
      ...value,
      ...List<int>.filled(
        requestedLength - value.length,
        0,
      ),
    ];
  }

  int _decimalToBcd(int value) {
    final tens = value ~/ 10;
    final units = value % 10;

    return (tens << 4) | units;
  }

  Uint8List? _extractAfl(
    Uint8List gpoData,
  ) {
    /*
     * Formato TLV 77:
     * el AFL se encuentra en la etiqueta 94.
     */
    final aflValues = _findAllTagValues(
      gpoData,
      0x94,
    );

    if (aflValues.isNotEmpty) {
      return aflValues.first;
    }

    /*
     * Formato primitivo 80:
     *
     * 80 LENGTH AIP(2 bytes) AFL(...)
     */
    final template80 = _findFirstTagValue(
      gpoData,
      0x80,
    );

    if (template80 != null && template80.length > 2) {
      return Uint8List.fromList(
        template80.sublist(2),
      );
    }

    return null;
  }

  String? _extractLastFourDigits(
    Uint8List data,
  ) {
    /*
     * Etiqueta 5A: Application Primary Account Number.
     */
    final panValues = _findAllTagValues(
      data,
      0x5A,
    );

    for (final panBytes in panValues) {
      final lastFour = _lastFourFromPanBytes(
        panBytes,
      );

      if (lastFour != null) {
        return lastFour;
      }
    }

    /*
     * Etiqueta 57: Track 2 Equivalent Data.
     *
     * Su formato comienza con:
     *
     * PAN + D + fecha + código de servicio + datos discrecionales.
     */
    final track2Values = _findAllTagValues(
      data,
      0x57,
    );

    for (final track2Bytes in track2Values) {
      final lastFour = _lastFourFromTrack2Bytes(
        track2Bytes,
      );

      if (lastFour != null) {
        return lastFour;
      }
    }

    return null;
  }

  String? _lastFourFromPanBytes(
    Uint8List bytes,
  ) {
    /*
     * El valor completo existe únicamente durante esta función.
     * Solo se devuelve la terminación.
     */
    var digits = _toHex(bytes)
        .replaceAll('F', '')
        .replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length < 4) {
      return null;
    }

    final lastFour = digits.substring(
      digits.length - 4,
    );

    /*
     * Se elimina la referencia al valor completo antes de salir.
     */
    digits = '';

    return lastFour;
  }

  String? _lastFourFromTrack2Bytes(
    Uint8List bytes,
  ) {
    /*
     * No se registra ni se devuelve el Track 2 completo.
     */
    var track2 = _toHex(bytes);

    final separatorIndex = track2.indexOf('D');

    if (separatorIndex <= 0) {
      track2 = '';
      return null;
    }

    var pan = track2.substring(
      0,
      separatorIndex,
    );

    pan = pan
        .replaceAll('F', '')
        .replaceAll(RegExp(r'[^0-9]'), '');

    if (pan.length < 4) {
      track2 = '';
      pan = '';
      return null;
    }

    final lastFour = pan.substring(
      pan.length - 4,
    );

    track2 = '';
    pan = '';

    return lastFour;
  }

  Future<Uint8List> _transceive(
    IsoDepAndroid isoDep,
    Uint8List command,
  ) async {
    var response = await isoDep.transceive(command);

    if (response.length < 2) {
      throw Exception(
        'La tarjeta devolvió una respuesta NFC incompleta.',
      );
    }

    /*
     * SW1 = 6C:
     * la tarjeta solicita repetir el comando con el Le correcto.
     */
    if (response[response.length - 2] == 0x6C) {
      final correctedLength = response.last;

      final correctedCommand = Uint8List.fromList(
        <int>[
          ...command.sublist(
            0,
            command.length - 1,
          ),
          correctedLength,
        ],
      );

      response = await isoDep.transceive(
        correctedCommand,
      );
    }

    /*
     * SW1 = 61:
     * existen más datos disponibles mediante GET RESPONSE.
     */
    if (response.length >= 2 &&
        response[response.length - 2] == 0x61) {
      final accumulated = <int>[
        ..._removeStatusWord(response),
      ];

      var remainingLength = response.last;

      while (true) {
        final getResponseCommand = Uint8List.fromList(
          <int>[
            0x00,
            0xC0,
            0x00,
            0x00,
            remainingLength,
          ],
        );

        final continuation = await isoDep.transceive(
          getResponseCommand,
        );

        if (continuation.length < 2) {
          throw Exception(
            'La tarjeta devolvió una continuación NFC incompleta.',
          );
        }

        accumulated.addAll(
          _removeStatusWord(continuation),
        );

        final sw1 = continuation[
            continuation.length - 2
        ];
        final sw2 = continuation.last;

        if (sw1 != 0x61) {
          accumulated.add(sw1);
          accumulated.add(sw2);
          break;
        }

        remainingLength = sw2;
      }

      response = Uint8List.fromList(accumulated);
    }

    return response;
  }

  bool _isSuccess(
    Uint8List response,
  ) {
    if (response.length < 2) {
      return false;
    }

    return response[response.length - 2] == 0x90 &&
        response.last == 0x00;
  }

  String _statusWord(
    Uint8List response,
  ) {
    if (response.length < 2) {
      return 'DESCONOCIDO';
    }

    return _toHex(
      Uint8List.fromList(
        response.sublist(
          response.length - 2,
        ),
      ),
    );
  }

  Uint8List _removeStatusWord(
    Uint8List response,
  ) {
    if (response.length < 2) {
      return Uint8List(0);
    }

    return Uint8List.fromList(
      response.sublist(
        0,
        response.length - 2,
      ),
    );
  }

  List<Uint8List> _findAllTagValues(
    Uint8List data,
    int searchedTag,
  ) {
    final values = <Uint8List>[];

    void parseRange(
      int start,
      int end,
    ) {
      int offset = start;

      while (offset < end) {
        final tagResult = _readTag(
          data,
          offset,
        );

        if (tagResult == null) {
          return;
        }

        final tag = tagResult.tag;
        final firstTagByte = data[offset];
        offset = tagResult.nextOffset;

        final lengthResult = _readLength(
          data,
          offset,
        );

        if (lengthResult == null) {
          return;
        }

        offset = lengthResult.nextOffset;

        final valueEnd = offset + lengthResult.length;

        if (valueEnd > end || valueEnd > data.length) {
          return;
        }

        final value = Uint8List.fromList(
          data.sublist(
            offset,
            valueEnd,
          ),
        );

        if (tag == searchedTag) {
          values.add(value);
        }

        final isConstructed =
            (firstTagByte & 0x20) == 0x20;

        if (isConstructed && value.isNotEmpty) {
          parseRange(
            offset,
            valueEnd,
          );
        }

        offset = valueEnd;
      }
    }

    parseRange(
      0,
      data.length,
    );

    return values;
  }

  Uint8List? _findFirstTagValue(
    Uint8List data,
    int searchedTag,
  ) {
    final values = _findAllTagValues(
      data,
      searchedTag,
    );

    return values.isEmpty
        ? null
        : values.first;
  }

  _TagReadResult? _readTag(
    Uint8List data,
    int offset,
  ) {
    if (offset >= data.length) {
      return null;
    }

    int tag = data[offset];
    int nextOffset = offset + 1;

    if ((tag & 0x1F) == 0x1F) {
      while (nextOffset < data.length) {
        final nextByte = data[nextOffset];

        tag = (tag << 8) | nextByte;
        nextOffset++;

        if ((nextByte & 0x80) == 0) {
          break;
        }
      }
    }

    return _TagReadResult(
      tag: tag,
      nextOffset: nextOffset,
    );
  }

  _LengthReadResult? _readLength(
    Uint8List data,
    int offset,
  ) {
    if (offset >= data.length) {
      return null;
    }

    final firstByte = data[offset];
    int nextOffset = offset + 1;

    if ((firstByte & 0x80) == 0) {
      return _LengthReadResult(
        length: firstByte,
        nextOffset: nextOffset,
      );
    }

    final lengthByteCount = firstByte & 0x7F;

    if (lengthByteCount == 0 ||
        lengthByteCount > 3 ||
        nextOffset + lengthByteCount > data.length) {
      return null;
    }

    int length = 0;

    for (int i = 0; i < lengthByteCount; i++) {
      length = (length << 8) | data[nextOffset];
      nextOffset++;
    }

    return _LengthReadResult(
      length: length,
      nextOffset: nextOffset,
    );
  }

  String? _detectBrand(
    String aid,
  ) {
    final normalizedAid = aid.toUpperCase();

    if (normalizedAid.startsWith('A000000003')) {
      return 'Visa';
    }

    if (normalizedAid.startsWith('A000000004')) {
      return 'Mastercard';
    }

    if (normalizedAid.startsWith('A000000025')) {
      return 'American Express';
    }

    if (normalizedAid.startsWith('A000000065')) {
      return 'JCB';
    }

    if (normalizedAid.startsWith('A000000152')) {
      return 'Discover';
    }

    return null;
  }

  String _toHex(
    Uint8List bytes,
  ) {
    return bytes
        .map(
          (byte) => byte
              .toRadixString(16)
              .padLeft(2, '0'),
        )
        .join()
        .toUpperCase();
  }

  Future<void> stopReading() async {
    if (!_sessionActive) {
      return;
    }

    _sessionActive = false;

    try {
      await NfcManager.instance.stopSession();
    } catch (_) {
      // La sesión puede haberse detenido previamente.
    }
  }
}

class _TagReadResult {
  const _TagReadResult({
    required this.tag,
    required this.nextOffset,
  });

  final int tag;
  final int nextOffset;
}

class _LengthReadResult {
  const _LengthReadResult({
    required this.length,
    required this.nextOffset,
  });

  final int length;
  final int nextOffset;
}