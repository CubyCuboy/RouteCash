import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/card_model.dart';
import '../../services/bank_card_nfc.dart';
import '../../utils/card_utils.dart';
import '../../l10n/app_localizations.dart';
import '../components/route_cash_buttons.dart';
import 'main_navigation_screen.dart';
import 'dart:math';

class _BankProductOption {
  const _BankProductOption({required this.label, required this.type});

  final String label;
  final RouteCashCardType type;
}

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_CL',
    symbol: r'$',
    decimalDigits: 0,
  );

  late final List<RouteCashCardModel> _cards = [
    RouteCashCardModel(
      id: '1',
      bankName: 'Banco Estado',
      productName: 'Cuenta Corriente',
      lastFourDigits: '7841',
      availableAmount: 485230,
      type: RouteCashCardType.debit,
      assetPath: 'cards/cuentarutll.png',
    ),
    RouteCashCardModel(
      id: '2',
      bankName: 'Scotiabank',
      productName: 'Cuenta Corriente',
      lastFourDigits: '3192',
      availableAmount: 128760,
      type: RouteCashCardType.debit,
      assetPath: 'cards/skotia.png',
    ),
    RouteCashCardModel(
      id: '3',
      bankName: 'Banco Santander',
      productName: 'WorldMember',
      lastFourDigits: '8901',
      availableAmount: 680000,
      type: RouteCashCardType.credit,
      assetPath: 'cards/worldmember.png',
    ),
    RouteCashCardModel(
      id: '4',
      bankName: 'Banco Falabella',
      productName: 'Tarjeta CMR Mastercard',
      lastFourDigits: '5521',
      availableAmount: 1240000,
      type: RouteCashCardType.credit,
      assetPath: 'cards/cmr.png',
    ),
  ];

  List<RouteCashCardModel> get _debitCards {
    return _cards
        .where((card) => card.type == RouteCashCardType.debit)
        .toList();
  }

  List<RouteCashCardModel> get _creditCards {
    return _cards
        .where((card) => card.type == RouteCashCardType.credit)
        .toList();
  }

  void _openCard(RouteCashCardModel card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CardDetailScreen(
          card: card,
          onDelete: () => _deleteCard(card),
        ),
      ),
    );
  }

  void _deleteCard(RouteCashCardModel card) {
    setState(() {
      _cards.removeWhere((item) => item.id == card.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarjeta ${card.bankName} eliminada.',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showAddCardSheet() {
    _openAddCardForm();
  }

  void _openAddCardForm() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AddCardFormBottomSheet(
          onCardAdded: (newCard) {
            setState(() {
              _cards.add(newCard);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '¡Tarjeta ${newCard.bankName} registrada con éxito!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () async {
                      final popped = await Navigator.maybePop(context);
                      if (!popped && context.mounted) {
                        MainNavigationScreen.popTabHistory(context);
                      }
                    },
                    backgroundColor: Colors.transparent,
                    borderColor: const Color(0xFFE2E2E2),
                    size: 42,
                    iconSize: 20,
                  ),
                  CircleIconButton(
                    icon: Icons.add,
                    backgroundColor: Colors.black,
                    iconColor: Colors.white,
                    onPressed: _showAddCardSheet,
                    size: 42,
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(32, 38, 32, 140),
                children: [
                  Text(
                    'TUS TARJETAS',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Todo tu dinero,\nen un lugar.',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 46,
                      height: 0.92,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Consulta tus cuentas, tarjetas de crédito y saldos disponibles.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 42),
                  _CardsSection(
                    title: 'CUENTAS DE DÉBITO',
                    cards: _debitCards,
                    currencyFormat: _currencyFormat,
                    onCardPressed: _openCard,
                  ),
                  const SizedBox(height: 38),
                  _CardsSection(
                    title: 'TARJETAS DE CRÉDITO',
                    cards: _creditCards,
                    currencyFormat: _currencyFormat,
                    onCardPressed: _openCard,
                  ),
                ],
              ),
            ),
              ],
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 18,
              child: SafeArea(
                top: false,
                child: RouteCashPrimaryButton(
                  text: 'Agregar nueva tarjeta',
                  onPressed: _showAddCardSheet,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardsSection extends StatelessWidget {
  const _CardsSection({
    required this.title,
    required this.cards,
    required this.currencyFormat,
    required this.onCardPressed,
  });

  final String title;
  final List<RouteCashCardModel> cards;
  final NumberFormat currencyFormat;
  final ValueChanged<RouteCashCardModel> onCardPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: const Color(0xFF999999),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        if (cards.isEmpty)
          const _EmptyCardState()
        else
          ...cards.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: RouteCashStoredCard(
                card: card,
                formattedAmount: currencyFormat.format(card.availableAmount),
                onPressed: () => onCardPressed(card),
              ),
            ),
          ),
      ],
    );
  }
}

class RouteCashStoredCard extends StatelessWidget {
  const RouteCashStoredCard({
    super.key,
    required this.card,
    required this.formattedAmount,
    required this.onPressed,
  });

  final RouteCashCardModel card;
  final String formattedAmount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE6E6E6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'routecash-card-${card.id}',
                child: Container(
                  width: 138,
                  height: 78,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CardImageWidget(card: card),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.bankName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9A9A9A),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          card.lastFourDigits,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF999999),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    card.type == RouteCashCardType.credit
                        ? 'DISPONIBLE'
                        : 'SALDO',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    formattedAmount,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFBBBBBB),
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackCard extends StatelessWidget {
  const _FallbackCard({required this.card});

  final RouteCashCardModel card;

  List<Color> _getBankGradient() {
    final name = card.bankName.toLowerCase();
    if (name.contains('estado')) {
      return const [Color(0xFF003057), Color(0xFF001B3A)];
    } else if (name.contains('scotia')) {
      return const [Color(0xFFCC0000), Color(0xFF7A0000)];
    } else if (name.contains('santander')) {
      return const [Color(0xFFEC0000), Color(0xFF8E0000)];
    } else if (name.contains('falabella')) {
      return const [Color(0xFF00875A), Color(0xFF004D34)];
    }
    return card.type == RouteCashCardType.credit
        ? const [Color(0xFF1E1E1E), Color(0xFF383838)]
        : const [Color(0xFF0168FF), Color(0xFF25A8F4)];
  }

  Color? _getAccentColor() {
    final name = card.bankName.toLowerCase();
    if (name.contains('estado')) {
      return const Color(0xFFE57200);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final accent = _getAccentColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getBankGradient(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.inter(color: Colors.white),
        child: Stack(
          children: [
            if (accent != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 35,
                  height: 3,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card.bankName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Icon(
                      Icons.nfc_rounded,
                      color: Colors.white70,
                      size: 10,
                    ),
                  ],
                ),
                Text(
                  card.productName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '•••• •••• •••• ${card.lastFourDigits}',
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      card.type == RouteCashCardType.credit ? 'VISA' : 'DEBIT',
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({
    super.key,
    required this.card,
    required this.onDelete,
  });

  final RouteCashCardModel card;
  final VoidCallback onDelete;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Eliminar tarjeta',
            style: GoogleFonts.playfairDisplay(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            '¿Seguro que deseas eliminar ${card.productName} terminada en ${card.lastFourDigits}?',
            style: GoogleFonts.inter(
              color: const Color(0xFF666666),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                'Eliminar',
                style: GoogleFonts.inter(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    onDelete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_CL',
      symbol: r'$',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CircleIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.transparent,
                borderColor: const Color(0xFFE2E2E2),
                size: 42,
                iconSize: 20,
              ),
            ),
            const SizedBox(height: 38),
            Text(
              'DETALLE DE TARJETA',
              style: GoogleFonts.inter(
                color: const Color(0xFF9D9D9D),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              card.productName,
              style: GoogleFonts.playfairDisplay(
                color: Colors.black,
                fontSize: 44,
                height: 0.95,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.7,
              ),
            ),
            const SizedBox(height: 30),
            Hero(
              tag: 'routecash-card-${card.id}',
              child: AspectRatio(
                aspectRatio: 1.75,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CardImageWidget(card: card),
                ),
              ),
            ),
            const SizedBox(height: 36),
            _CardInformationRow(label: 'Banco', value: card.bankName),
            _CardInformationRow(label: 'Producto', value: card.productName),
            _CardInformationRow(
              label: 'Terminación',
              value: '•••• •••• •••• ${card.lastFourDigits}',
            ),
            _CardInformationRow(
              label: card.type == RouteCashCardType.credit
                  ? 'Cupo disponible'
                  : 'Saldo disponible',
              value: currencyFormat.format(card.availableAmount),
            ),
            const SizedBox(height: 34),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Eliminar tarjeta'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInformationRow extends StatelessWidget {
  const _CardInformationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 19),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E2E2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF999999),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCardState extends StatelessWidget {
  const _EmptyCardState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.credit_card_off_outlined,
            color: Color(0xFFAAAAAA),
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay tarjetas registradas',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CachedCardImageUrl {
  const _CachedCardImageUrl({required this.url, required this.expiresAt});

  final String? url;
  final DateTime expiresAt;

  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class _CardImageService {
  _CardImageService._();

  static final _CardImageService instance = _CardImageService._();

  static const String _bucketName = 'images';
  static const Duration _signedUrlDuration = Duration(days: 7);
  static const Duration _refreshBeforeExpiry = Duration(minutes: 10);
  static const Duration _missingImageCacheDuration = Duration(minutes: 10);

  final Map<String, _CachedCardImageUrl> _cache = {};
  final Map<String, Future<String?>> _pendingRequests = {};

  Future<String?> getImageUrl(String storagePath) {
    final cached = _cache[storagePath];
    if (cached != null && cached.isValid) {
      return Future.value(cached.url);
    }

    return _pendingRequests.putIfAbsent(
      storagePath,
      () => _loadImageUrl(storagePath),
    );
  }

  Future<String?> _loadImageUrl(String storagePath) async {
    try {
      final url = await Supabase.instance.client.storage
          .from(_bucketName)
          .createSignedUrl(storagePath, _signedUrlDuration.inSeconds);

      _cache[storagePath] = _CachedCardImageUrl(
        url: url,
        expiresAt: DateTime.now().add(
          _signedUrlDuration - _refreshBeforeExpiry,
        ),
      );
      return url;
    } catch (error) {
      debugPrint('Imagen no disponible en Supabase: $storagePath ($error)');
      _cache[storagePath] = _CachedCardImageUrl(
        url: null,
        expiresAt: DateTime.now().add(_missingImageCacheDuration),
      );
      return null;
    } finally {
      _pendingRequests.remove(storagePath);
    }
  }
}

String resolveCardImagePath(RouteCashCardModel card) {
  // La imagen ya fue seleccionada y guardada cuando se creó la tarjeta.
  // No se vuelve a aleatorizar durante los rebuilds de Flutter.
  return card.assetPath;
}

class CardImageWidget extends StatefulWidget {
  const CardImageWidget({super.key, required this.card});

  final RouteCashCardModel card;

  @override
  State<CardImageWidget> createState() => _CardImageWidgetState();
}

class _CardImageWidgetState extends State<CardImageWidget> {
  Future<String?>? _imageFuture;
  late String _resolvedImagePath;

  bool get _isLocalAsset => _resolvedImagePath.startsWith('assets/');

  @override
  void initState() {
    super.initState();
    _prepareImage();
  }

  @override
  void didUpdateWidget(covariant CardImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldPath = resolveCardImagePath(oldWidget.card);
    final newPath = resolveCardImagePath(widget.card);

    if (oldPath != newPath ||
        oldWidget.card.bankName != widget.card.bankName ||
        oldWidget.card.productName != widget.card.productName) {
      _prepareImage();
    }
  }

  void _prepareImage() {
    _resolvedImagePath = resolveCardImagePath(widget.card);

    if (_resolvedImagePath.isEmpty || _isLocalAsset) {
      _imageFuture = null;
      return;
    }

    _imageFuture = _CardImageService.instance.getImageUrl(_resolvedImagePath);
  }

  @override
  Widget build(BuildContext context) {
    if (_resolvedImagePath.isEmpty) {
      return _FallbackCard(card: widget.card);
    }

    if (_isLocalAsset) {
      return Image.asset(
        _resolvedImagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _FallbackCard(card: widget.card),
      );
    }

    return FutureBuilder<String?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color(0xFFF1F1F1),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }

        final imageUrl = snapshot.data;
        if (imageUrl == null || imageUrl.isEmpty) {
          return _FallbackCard(card: widget.card);
        }

        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, error, _) {
            debugPrint('No se pudo mostrar $_resolvedImagePath: $error');
            return _FallbackCard(card: widget.card);
          },
        );
      },
    );
  }
}

class _AddCardFormBottomSheet extends StatefulWidget {
  const _AddCardFormBottomSheet({required this.onCardAdded});

  final ValueChanged<RouteCashCardModel> onCardAdded;

  @override
  State<_AddCardFormBottomSheet> createState() =>
      _AddCardFormBottomSheetState();
}

class _AddCardFormBottomSheetState extends State<_AddCardFormBottomSheet> {
  static const List<String> _bancoEstadoCardImages = [
    'cards/cuentarutgray.png',
    'cards/cuentarutll.png',
    'cards/cuentarutorange.png',
  ];

  final Random _random = Random();

  RouteCashCardType _cardType = RouteCashCardType.debit;
  late String _selectedBank;
  late String _selectedProduct;

  final TextEditingController _lastFourController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  final BankCardNfcService _nfcService = BankCardNfcService();

  bool _isScanningNfc = false;
  String? _nfcStatusKey;

  String? _bankError;
  String? _productError;
  String? _lastFourError;
  String? _expiryDateError;

  static const String _selectBankLabel = 'Selecciona un banco';
  static const String _selectProductLabel = 'Selecciona un tipo de cuenta';

  static const List<String> _chileanBanks = [
    _selectBankLabel,
    'BancoEstado',
    'Banco Santander',
    'Banco de Chile',
    'BCI',
    'Banco Falabella / CMR',
  ];

  static const Map<String, List<_BankProductOption>> _productsByBank = {
    'BancoEstado': [
      _BankProductOption(label: 'CuentaRUT', type: RouteCashCardType.debit),
      _BankProductOption(label: 'Cuenta Vista', type: RouteCashCardType.debit),
      _BankProductOption(
        label: 'Cuenta Corriente Digital',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Cuenta de Ahorro',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Tarjeta de Crédito BancoEstado',
        type: RouteCashCardType.credit,
      ),
    ],
    'Banco Santander': [
      _BankProductOption(
        label: 'Cuenta Corriente Digital',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Cuenta Vista Más Lucas',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Cuenta de Ahorro',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Tarjeta de Crédito Santander',
        type: RouteCashCardType.credit,
      ),
    ],
    'Banco de Chile': [
      _BankProductOption(label: 'Cuenta FAN', type: RouteCashCardType.debit),
      _BankProductOption(label: 'Cuenta Vista', type: RouteCashCardType.debit),
      _BankProductOption(
        label: 'Cuenta Corriente',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Cuenta de Ahorro',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Tarjeta de Crédito Banco de Chile',
        type: RouteCashCardType.credit,
      ),
    ],
    'BCI': [
      _BankProductOption(
        label: 'Cuenta Digital BCI',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(label: 'Cuenta Vista', type: RouteCashCardType.debit),
      _BankProductOption(
        label: 'Cuenta Corriente',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Tarjeta de Crédito BCI',
        type: RouteCashCardType.credit,
      ),
    ],
    'Banco Falabella / CMR': [
      _BankProductOption(
        label: 'Cuenta Corriente Banco Falabella',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Cuenta Vista Banco Falabella',
        type: RouteCashCardType.debit,
      ),
      _BankProductOption(
        label: 'Tarjeta CMR Mastercard',
        type: RouteCashCardType.credit,
      ),
    ],
  };

  List<_BankProductOption> get _availableProductOptions {
    return _productsByBank[_selectedBank] ?? const [];
  }

  List<String> get _availableProductLabels {
    return [
      _selectProductLabel,
      ..._availableProductOptions.map((product) => product.label),
    ];
  }

  RouteCashCardType _typeForSelectedProduct() {
    for (final product in _availableProductOptions) {
      if (product.label == _selectedProduct) {
        return product.type;
      }
    }

    return RouteCashCardType.debit;
  }

  bool _didInitializeDependencies = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didInitializeDependencies) return;

    _selectedBank = _selectBankLabel;
    _selectedProduct = _selectProductLabel;
    _didInitializeDependencies = true;
  }

  @override
  void dispose() {
    _nfcService.stopReading();
    _lastFourController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  String _translateNfcStatus(String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      case 'nfcStatusIdle':
        return l10n.nfcStatusIdle;
      case 'nfcStatusDetected':
        return l10n.nfcStatusDetected;
      case 'nfcStatusReadingConfig':
        return l10n.nfcStatusReadingConfig;
      case 'nfcStatusRetrievingData':
        return l10n.nfcStatusRetrievingData;
      case 'nfcStatusSuccess':
        return l10n.nfcStatusSuccess;
      case 'nfcErrorAvailability':
        return l10n.nfcErrorAvailability;
      case 'nfcErrorSessionActive':
        return l10n.nfcErrorSessionActive;
      case 'nfcErrorPpse':
        return l10n.nfcErrorPpse;
      case 'nfcErrorIncompatible':
        return l10n.nfcErrorIncompatible;
      case 'nfcErrorNoAid':
        return l10n.nfcErrorNoAid;
      case 'nfcErrorAidAccess':
        return l10n.nfcErrorAidAccess;
      case 'nfcErrorRetrieveFail':
        return l10n.nfcErrorRetrieveFail;
      case 'nfcTimeout':
        return l10n.nfcTimeout;
      case 'nfcCancel':
        return l10n.nfcCancel;
      default:
        return key;
    }
  }

  Future<void> _scanCardWithNfc() async {
    if (_isScanningNfc) return;

    setState(() {
      _isScanningNfc = true;
      _nfcStatusKey = 'nfcStatusIdle';
    });

    try {
      final result = await _nfcService.readPaymentCard();

      if (!mounted) return;

      setState(() {
        _nfcStatusKey = result.message;
        _applyNfcResult(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _translateNfcStatus(result.message),
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      final key = error.toString();

      setState(() {
        _nfcStatusKey = key;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _translateNfcStatus(key),
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isScanningNfc = false;
        });
      }
    }
  }

  void _applyNfcResult(BankCardNfcResult result) {
    if (result.bankName != null && result.bankName != 'Banco Emisor') {
      final matchedBank = _chileanBanks.firstWhere(
        (bank) => bank.toLowerCase().contains(result.bankName!.toLowerCase()),
        orElse: () => _chileanBanks.first,
      );
      _selectedBank = matchedBank;
      _bankError = null;
    }

    final lastFour =
        (result.cardNumber != null && result.cardNumber!.length >= 4)
            ? result.cardNumber!.substring(result.cardNumber!.length - 4)
            : null;
    if (lastFour != null && RegExp(r'^\d{4}$').hasMatch(lastFour)) {
      _lastFourController.value = TextEditingValue(
        text: lastFour,
        selection: TextSelection.collapsed(offset: lastFour.length),
      );
      _lastFourError = null;
    }

    if (result.expiryDate != null) {
      _formatExpiryDate(
        CardUtils.formatExpiryDate(result.expiryDate!.replaceAll('/', '')),
      );
      _expiryDateError = null;
    }
  }

  Future<void> _cancelNfcScan() async {
    await _nfcService.stopReading();

    if (!mounted) return;

    setState(() {
      _isScanningNfc = false;
      _nfcStatusKey = 'nfcCancel';
    });
  }

  void _formatLastFour(String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    if (_lastFourController.text != digits) {
      _lastFourController.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }

    if (_lastFourError != null && RegExp(r'^\d{4}$').hasMatch(digits)) {
      setState(() {
        _lastFourError = null;
      });
    }
  }

  void _formatExpiryDate(String value) {
    final formatted = CardUtils.formatExpiryDate(value);
    if (_expiryDateController.text != formatted) {
      _expiryDateController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    if (_expiryDateError != null &&
        (formatted.isEmpty || CardUtils.validateExpiryDate(formatted))) {
      setState(() {
        _expiryDateError = null;
      });
    }
  }

  String _getSelectedCardImagePath() {
    final bankName = _selectedBank.trim().toLowerCase();
    if (bankName.contains('banco estado') || bankName.contains('bancoestado')) {
      final randomIndex = _random.nextInt(_bancoEstadoCardImages.length);
      return _bancoEstadoCardImages[randomIndex];
    }
    if (bankName.contains('falabella')) return 'cards/cmr.png';
    if (bankName.contains('scotiabank') || bankName.contains('scotia'))
      return 'cards/skotia.png';
    if (bankName.contains('santander') &&
        _selectedProduct.toLowerCase().contains('santander'))
      return 'cards/worldmember.png';
    return '';
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final lastFour = _lastFourController.text.trim();
    final expiryDate = _expiryDateController.text.trim();

    final bankError = _selectedBank == _selectBankLabel
        ? 'Selecciona un banco.'
        : null;

    final productError = _selectedProduct == _selectProductLabel
        ? 'Selecciona un tipo de cuenta o tarjeta.'
        : null;

    final lastFourError = RegExp(r'^\d{4}$').hasMatch(lastFour)
        ? null
        : 'Ingresa exactamente los últimos 4 dígitos.';

    final expiryError =
        expiryDate.isNotEmpty && !CardUtils.validateExpiryDate(expiryDate)
        ? 'Ingresa una fecha de vencimiento válida.'
        : null;

    setState(() {
      _bankError = bankError;
      _productError = productError;
      _lastFourError = lastFourError;
      _expiryDateError = expiryError;
    });

    if (bankError != null ||
        productError != null ||
        lastFourError != null ||
        expiryError != null) {
      return;
    }

    _cardType = _typeForSelectedProduct();

    final newCard = RouteCashCardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankName: _selectedBank,
      productName: _selectedProduct,
      lastFourDigits: lastFour,
      availableAmount: 0.0,
      type: _cardType,
      assetPath: _getSelectedCardImagePath(),
      expiryDate: expiryDate.isEmpty ? null : expiryDate,
    );

    widget.onCardAdded(newCard);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final modalHeight = mediaQuery.size.height * 0.92;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: modalHeight,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(28, 14, 28, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D0D0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.transparent,
                borderColor: const Color(0xFFE2E2E2),
                size: 42,
                iconSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingresar tarjeta',
              style: GoogleFonts.playfairDisplay(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Selecciona tu banco, el tipo de cuenta y los últimos 4 dígitos.',
              style: GoogleFonts.inter(
                color: const Color(0xFF999999),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E2E2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.nfc_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leer tarjeta con NFC',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Detecta una tarjeta contactless y reconoce su red.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF999999),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_nfcStatusKey != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _translateNfcStatus(_nfcStatusKey!),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF666666),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isScanningNfc
                          ? _cancelNfcScan
                          : _scanCardWithNfc,
                      icon: _isScanningNfc
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.nfc_rounded),
                      label: Text(
                        _isScanningNfc
                            ? 'Cancelar lectura'
                            : 'Escanear con NFC',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Por seguridad, RouteCash conserva únicamente los últimos 4 dígitos. No guarda PAN completo, CVV, PIN, saldo ni movimientos.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Banco'),
            _buildDropdownField(
              value: _selectedBank,
              items: _chileanBanks,
              onChanged: (val) {
                if (val == null) return;

                setState(() {
                  _selectedBank = val;
                  _selectedProduct = _selectProductLabel;
                  _cardType = RouteCashCardType.debit;
                  _bankError = null;
                  _productError = null;
                });
              },
              icon: Icons.account_balance_outlined,
              errorText: _bankError,
            ),
            const SizedBox(height: 14),
            _buildLabel('Tipo de cuenta o tarjeta'),
            _buildDropdownField(
              value: _selectedProduct,
              items: _availableProductLabels,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedProduct = val;
                    _cardType = _typeForSelectedProduct();
                    _productError = null;
                  });
                }
              },
              icon: Icons.subtitles_outlined,
              errorText: _productError,
            ),
            const SizedBox(height: 14),
            _buildLabel('Ingresa los últimos 4 dígitos de tu tarjeta'),
            _buildTextField(
              controller: _lastFourController,
              hint: '1234',
              icon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              onChanged: _formatLastFour,
              maxLength: 4,
              errorText: _lastFourError,
            ),
            const SizedBox(height: 14),
            _buildLabel('Fecha de vencimiento (opcional)'),
            _buildTextField(
              controller: _expiryDateController,
              hint: 'MM/AA (ej: 12/28)',
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
              onChanged: (val) => _formatExpiryDate(val),
              maxLength: 5,
              errorText: _expiryDateError,
            ),                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  28,
                  14,
                  28,
                  18 + mediaQuery.padding.bottom,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                ),
                child: RouteCashPrimaryButton(
                  text: AppLocalizations.of(context)!.saveCard,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFF666666),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    String? errorText,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: items.contains(value) ? value : items.first,
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF888888),
      ),
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 19),
        errorText: errorText,
        errorMaxLines: 2,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
    int? maxLength,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        counterText: '',
        errorText: errorText,
        errorMaxLines: 2,
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFFB0B0B0),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 19),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
