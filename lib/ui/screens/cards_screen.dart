import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/card_model.dart';
import '../components/route_cash_buttons.dart';

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
      assetPath:
          'https://gpufgmlpbpydojnvgwid.supabase.co/storage/v1/object/sign/images/cards/bancoestadoazul.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8zZWFhOGE4Zi00ZjA1LTQxMWUtODE2My0wNmJlYzEzMjkwZjgiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJpbWFnZXMvY2FyZHMvYmFuY29lc3RhZG9henVsLnBuZyIsInNjb3BlIjoiZG93bmxvYWQiLCJpYXQiOjE3ODU0NzcwNjMsImV4cCI6MTc4NjA4MTg2M30.2bKmJv6IvuT1mLXe7ZYEAoQ8CucSMcFeYCW64FJfFaw',
    ),
    RouteCashCardModel(
      id: '2',
      bankName: 'Scotiabank',
      productName: 'Cuenta Corriente',
      lastFourDigits: '3192',
      availableAmount: 128760,
      type: RouteCashCardType.debit,
      assetPath:
          'https://gpufgmlpbpydojnvgwid.supabase.co/storage/v1/object/sign/images/cards/skotia.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8zZWFhOGE4Zi00ZjA1LTQxMWUtODE2My0wNmJlYzEzMjkwZjgiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJpbWFnZXMvY2FyZHMvc2tvdGlhLnBuZyIsInNjb3BlIjoiZG93bmxvYWQiLCJpYXQiOjE3ODU0Nzc1MDMsImV4cCI6MTc4NjA4MjMwM30.EL0D8KXRngTjRNahjcWc1z-zZ04tcklYQXTpmb9YgMM',
    ),
    RouteCashCardModel(
      id: '3',
      bankName: 'Banco Santander',
      productName: 'WorldMember',
      lastFourDigits: '8901',
      availableAmount: 680000,
      type: RouteCashCardType.credit,
      assetPath:
          'https://gpufgmlpbpydojnvgwid.supabase.co/storage/v1/object/sign/images/cards/worldmember.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8zZWFhOGE4Zi00ZjA1LTQxMWUtODE2My0wNmJlYzEzMjkwZjgiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJpbWFnZXMvY2FyZHMvd29ybGRtZW1iZXIucG5nIiwic2NvcGUiOiJkb3dubG9hZCIsImlhdCI6MTc4NTQ3Nzg4NiwiZXhwIjoxNzg2MDgyNjg2fQ.IKX63CPLqq920SnnQQ1dAwGyqjJBXPP8fx_DANCB1Wk',
    ),
    RouteCashCardModel(
      id: '4',
      bankName: 'Banco Falabella',
      productName: 'CMR Falabella',
      lastFourDigits: '5521',
      availableAmount: 1240000,
      type: RouteCashCardType.credit,
      assetPath: 'https://gpufgmlpbpydojnvgwid.supabase.co/storage/v1/object/sign/images/cards/cmr.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8zZWFhOGE4Zi00ZjA1LTQxMWUtODE2My0wNmJlYzEzMjkwZjgiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJpbWFnZXMvY2FyZHMvY21yLnBuZyIsInNjb3BlIjoiZG93bmxvYWQiLCJpYXQiOjE3ODU0Nzg1MjMsImV4cCI6MTc4NjA4MzMyM30.kDdgVe1Il9f9H7mU_3pFibb-TovF-m0Y49OEZqKrGJ0',
    ),
  ];

  static String _getCardImageUrl(String fileName, String fallbackAsset) {
    try {
      final url = Supabase.instance.client.storage
          .from('cards')
          .getPublicUrl(fileName);
      if (url.isNotEmpty &&
          !url.contains('your-supabase-project') &&
          !url.contains('example.com')) {
        return url;
      }
      return fallbackAsset;
    } catch (_) {
      return fallbackAsset;
    }
  }

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
          },
          onCreditPressed: () {
            Navigator.pop(context);
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
                    onPressed: () => Navigator.maybePop(context),
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
                  width: 112,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CardImageWidget(card: card),
                ),
              ),
              const SizedBox(width: 15),
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
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
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
                aspectRatio: 1.58,
                child: Container(
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

class CardImageWidget extends StatelessWidget {
  const CardImageWidget({super.key, required this.card});

  final RouteCashCardModel card;

  @override
  Widget build(BuildContext context) {
    final String path = card.assetPath;
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _FallbackCard(card: card);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
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
        },
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _FallbackCard(card: card);
      },
    );
  }
}
