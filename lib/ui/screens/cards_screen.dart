import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/card_model.dart';
import '../components/route_cash_buttons.dart';
import 'main_navigation_screen.dart';
import 'dart:math';

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
      productName: 'CMR Debito Falabella',
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
      MaterialPageRoute(builder: (_) => CardDetailScreen(card: card)),
    );
  }

  void _showAddCardSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AddCardBottomSheet(
          onDebitPressed: () {
            Navigator.pop(context);
            _openAddCardForm(RouteCashCardType.debit);
          },
          onCreditPressed: () {
            Navigator.pop(context);
            _openAddCardForm(RouteCashCardType.credit);
          },
        );
      },
    );
  }

  void _openAddCardForm(RouteCashCardType defaultType) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _AddCardFormBottomSheet(
          initialType: defaultType,
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
        child: Column(
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
                padding: const EdgeInsets.fromLTRB(32, 38, 32, 40),
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
                  const SizedBox(height: 42),
                  RouteCashPrimaryButton(
                    text: 'Agregar nueva tarjeta',
                    onPressed: _showAddCardSheet,
                  ),
                ],
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
                    const SizedBox(height: 6),
                    Text(
                      '•••• ${card.lastFourDigits}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF999999),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
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
                      '•••• ${card.lastFourDigits}',
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
  const CardDetailScreen({super.key, required this.card});

  final RouteCashCardModel card;

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
              value: '•••• ${card.lastFourDigits}',
            ),
            _CardInformationRow(
              label: card.type == RouteCashCardType.credit
                  ? 'Cupo disponible'
                  : 'Saldo disponible',
              value: currencyFormat.format(card.availableAmount),
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

class _AddCardBottomSheet extends StatelessWidget {
  const _AddCardBottomSheet({
    required this.onDebitPressed,
    required this.onCreditPressed,
  });

  final VoidCallback onDebitPressed;
  final VoidCallback onCreditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        28,
        14,
        28,
        28 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 28),
          Text(
            'Agregar tarjeta',
            style: GoogleFonts.playfairDisplay(
              color: Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona el tipo de producto que quieres registrar.',
            style: GoogleFonts.inter(
              color: const Color(0xFF999999),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 26),
          _AddCardOption(
            icon: Icons.account_balance_outlined,
            title: 'Cuenta de débito',
            subtitle: 'Cuenta corriente o cuenta vista',
            onPressed: onDebitPressed,
          ),
          const SizedBox(height: 12),
          _AddCardOption(
            icon: Icons.credit_card_outlined,
            title: 'Tarjeta de crédito',
            subtitle: 'Cupo, deuda y fecha de pago',
            onPressed: onCreditPressed,
          ),
        ],
      ),
    );
  }
}

class _AddCardOption extends StatelessWidget {
  const _AddCardOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 21),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xFFAAAAAA),
                size: 19,
              ),
            ],
          ),
        ),
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
        errorBuilder: (_, __, ___) => _FallbackCard(card: widget.card),
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
          errorBuilder: (_, error, ___) {
            debugPrint('No se pudo mostrar $_resolvedImagePath: $error');
            return _FallbackCard(card: widget.card);
          },
        );
      },
    );
  }
}

class _AddCardFormBottomSheet extends StatefulWidget {
  const _AddCardFormBottomSheet({
    required this.initialType,
    required this.onCardAdded,
  });

  final RouteCashCardType initialType;
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

  late RouteCashCardType _cardType;
  late String _selectedBank;
  late String _selectedProduct;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();


  static const List<String> _chileanBanks = [
    'Banco Estado',
    'Banco de Chile / Edwards',
    'Banco Santander',
    'Scotiabank Chile',
    'BCI (Banco de Crédito e Inversiones)',
    'Banco Falabella',
    'Banco BICE',
    'Banco Security',
    'Itaú Chile',
    'Tenpo',
    'MACH (Bci)',
    'Mercado Pago',
    'Coopeuch',
    'Consorcio',
    'Otro Banco',
  ];

  static const List<String> _baseDebitProducts = [
    'Cuenta Corriente',
    'Cuenta RUT / Vista',
    'Cuenta Digital / Prepago',
    'Cuenta de Ahorro',
  ];

  List<String> get _debitProducts {
    if (_selectedBank == 'Banco Estado') {
      return const [
        'Cuenta Corriente',
        'Cuenta RUT',
        'Cuenta Vista',
        'Cuenta Digital / Prepago',
        'Cuenta de Ahorro',
      ];
    }

    return _baseDebitProducts;
  }

  static const List<String> _creditProducts = [
    'Tarjeta de Crédito Visa',
    'Tarjeta de Crédito Mastercard',
    'Tarjeta de Crédito Signature / Black',
    'CMR Falabella',
    'Cencosud Scotiabank',
    'Lider Bci',
    'Tarjeta Ripley',
  ];

  @override
  void initState() {
    super.initState();
    _cardType = widget.initialType;
    _selectedBank = _chileanBanks.first;
    _selectedProduct = _cardType == RouteCashCardType.debit
        ? _debitProducts.first
        : _creditProducts.first;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onTypeChanged(RouteCashCardType newType) {
    setState(() {
      _cardType = newType;
      _selectedProduct = _cardType == RouteCashCardType.debit
          ? _debitProducts.first
          : _creditProducts.first;
    });
  }

  void _formatCardNumber(String value) {
    String clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 16) clean = clean.substring(0, 16);
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    final formatted = buffer.toString();
    if (_cardNumberController.text != formatted) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _formatExpiryDate(String value) {
    String clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 4) clean = clean.substring(0, 4);
    String formatted = clean;
    if (clean.length >= 3) {
      formatted = '${clean.substring(0, 2)}/${clean.substring(2)}';
    }
    if (_expiryDateController.text != formatted) {
      _expiryDateController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _getSelectedCardImagePath() {
    final bankName = _selectedBank.trim().toLowerCase();
    if (bankName.contains('banco estado') || bankName.contains('bancoestado')) {
      final randomIndex = _random.nextInt(_bancoEstadoCardImages.length);
      return _bancoEstadoCardImages[randomIndex];
    }
    if (bankName.contains('falabella')) return 'cards/cmr.png';
    if (bankName.contains('scotiabank') || bankName.contains('scotia')) return 'cards/skotia.png';
    if (bankName.contains('santander') && _selectedProduct.toLowerCase().contains('worldmember')) return 'cards/worldmember.png';
    return '';
  }

  void _submit() {
    final rawNumber =
        _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final lastFour = rawNumber.length >= 4
        ? rawNumber.substring(rawNumber.length - 4)
        : (rawNumber.isNotEmpty ? rawNumber.padLeft(4, '0') : '0000');

    final newCard = RouteCashCardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankName: _selectedBank,
      productName: _selectedProduct,
      lastFourDigits: lastFour,
      availableAmount: 0.0,
      type: _cardType,
      assetPath: _getSelectedCardImagePath(),
      cardNumber: _cardNumberController.text,
      expiryDate: _expiryDateController.text,
      cvv: _cvvController.text,
    );

    widget.onCardAdded(newCard);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final currentProducts = _cardType == RouteCashCardType.debit
        ? _debitProducts
        : _creditProducts;

    return Container(
      padding: EdgeInsets.fromLTRB(28, 14, 28, 28 + bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 20),
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
              'Selecciona tu banco y datos de tarjeta.',
              style: GoogleFonts.inter(
                color: const Color(0xFF999999),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _TypeChip(
                    label: 'Débito',
                    isSelected: _cardType == RouteCashCardType.debit,
                    onTap: () => _onTypeChanged(RouteCashCardType.debit),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeChip(
                    label: 'Crédito',
                    isSelected: _cardType == RouteCashCardType.credit,
                    onTap: () => _onTypeChanged(RouteCashCardType.credit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildLabel('Banco'),
            _buildDropdownField(
              value: _selectedBank,
              items: _chileanBanks,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  _selectedBank = val;
                  if (_cardType == RouteCashCardType.debit &&
                      !_debitProducts.contains(_selectedProduct)) {
                    _selectedProduct = _debitProducts.first;
                  }
                });
              },
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 14),
            _buildLabel('Nombre del Producto / Tipo de Cuenta'),
            _buildDropdownField(
              value: _selectedProduct,
              items: currentProducts,
              onChanged: (val) {
                if (val != null) setState(() => _selectedProduct = val);
              },
              icon: Icons.subtitles_outlined,
            ),
            const SizedBox(height: 14),
            _buildLabel('Número de Tarjeta'),
            _buildTextField(
              controller: _cardNumberController,
              hint: '1234 5678 9012 3456',
              icon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              onChanged: _formatCardNumber,
              maxLength: 19,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Fecha Caducidad'),
                      _buildTextField(
                        controller: _expiryDateController,
                        hint: 'MM/AA (ej: 12/28)',
                        icon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: _formatExpiryDate,
                        maxLength: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Código Trasero (CVC)'),
                      _buildTextField(
                        controller: _cvvController,
                        hint: '123',
                        icon: Icons.lock_outline,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            RouteCashPrimaryButton(text: 'Guardar Tarjeta', onPressed: _submit),
          ],
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
  }) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : items.first,
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF888888)),
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 19),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
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
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFFB0B0B0),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 19),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE2E2E2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}