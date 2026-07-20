import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/expense_category.dart';
import '../../viewmodels/report_view_model.dart';
import '../components/route_cash_buttons.dart';
import 'dart:ui' as ui;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late final ReportViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ReportViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    _viewModel.setSelectedIndex(index);

    if (index == 0) {
      Navigator.pop(context);
    }
  }

  bool _isSameMonth(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month;
  }

  String _formatMonth(
    BuildContext context,
    DateTime date, {
    bool includeYear = true,
  }) {
    final locale =
        Localizations.localeOf(context).toLanguageTag();

    final formatter = includeYear
        ? DateFormat.yMMMM(locale)
        : DateFormat.MMMM(locale);

    return formatter.format(date);
  }

  String _formatCurrency(
    BuildContext context,
    double amount, {
    bool showSign = false,
  }) {
    final locale =
        Localizations.localeOf(context).toLanguageTag();

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '\$',
      decimalDigits: 0,
    );

    final formattedAmount = formatter.format(amount.abs());

    if (!showSign) {
      return formattedAmount;
    }

    if (amount > 0) {
      return '+$formattedAmount';
    }

    if (amount < 0) {
      return '-$formattedAmount';
    }

    return formattedAmount;
  }

  String _getCategoryName(
    AppLocalizations strings,
    ExpenseCategoryType type,
  ) {
    switch (type) {
      case ExpenseCategoryType.shopping:
        return strings.expenseCategoryShopping;

      case ExpenseCategoryType.housing:
        return strings.expenseCategoryHousing;

      case ExpenseCategoryType.food:
        return strings.expenseCategoryFood;

      case ExpenseCategoryType.transport:
        return strings.expenseCategoryTransport;

      case ExpenseCategoryType.services:
        return strings.expenseCategoryServices;

      case ExpenseCategoryType.entertainment:
        return strings.expenseCategoryEntertainment;
    }
  }

  String _getBalanceComparisonText(
    BuildContext context,
    AppLocalizations strings,
  ) {
    final comparisonMonth = _formatMonth(
      context,
      _viewModel.comparisonMonth,
      includeYear: false,
    );

    return strings.balanceMoreThanMonth(
      _viewModel.balanceComparisonPercentage,
      comparisonMonth,
    );
  }

  void _showMonthSelector() {
    final strings = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (bottomSheetContext) {
        return ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  18,
                  24,
                  30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8D8D8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      strings.selectMonth,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._viewModel.months.map((month) {
                      return _MonthOption(
                        month: _formatMonth(context, month),
                        selected: _isSameMonth(
                          _viewModel.selectedMonth,
                          month,
                        ),
                        onTap: () {
                          _viewModel.selectMonth(month);
                          Navigator.pop(bottomSheetContext);
                        },
                      );
                    }),
                  ],
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
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(),
                        const SizedBox(height: 28),
                        _buildHeading(),
                        const SizedBox(height: 24),
                        _buildBalanceCard(),
                        const SizedBox(height: 30),
                        _buildChartSection(),
                        const SizedBox(height: 32),
                        _buildMostSpentSection(),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavigation(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final strings = AppLocalizations.of(context)!;

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              size: 38,
              iconSize: 19,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFFE4E4E4),
            ),
          ),
          Text(
            strings.reportTitle,
            style: GoogleFonts.dmSerifDisplay(
              color: Colors.black,
              fontSize: 30,
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CircleIconButton(
              icon: Icons.keyboard_arrow_down,
              onPressed: _showMonthSelector,
              size: 38,
              iconSize: 19,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFFE4E4E4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    final strings = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatMonth(
              context,
              _viewModel.selectedMonth,
            ).toUpperCase(),
            style: GoogleFonts.inter(
              color: const Color(0xFF9A9A9A),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            strings.monthInNumbers,
            style: GoogleFonts.dmSerifDisplay(
              color: Colors.black,
              fontSize: 38,
              height: 1,
              fontWeight: FontWeight.w400,
              letterSpacing: -1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    final strings = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 132,
      padding: const EdgeInsets.fromLTRB(
        19,
        20,
        19,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.monthlyBalanceLabel,
            style: GoogleFonts.inter(
              color: const Color(0xFF909090),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 19),
          Text(
            _formatCurrency(
              context,
              _viewModel.monthlyBalance,
              showSign: true,
            ),
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 36,
              height: 1,
              fontWeight: FontWeight.w400,
              letterSpacing: -1,
            ),
          ),
          const Spacer(),
          Text(
            _getBalanceComparisonText(
              context,
              strings,
            ),
            style: GoogleFonts.inter(
              color: const Color(0xFF8E8E8E),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    final strings = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              strings.weeklyFlow,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              strings.expensesAndIncome,
              style: GoogleFonts.inter(
                color: const Color(0xFF999999),
                fontSize: 8,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 138,
          width: double.infinity,
          child: CustomPaint(
            painter: WeeklyFlowChartPainter(
              expenses: _viewModel.weeklyExpenses,
              incomes: _viewModel.weeklyIncomes,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMostSpentSection() {
    final strings = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              strings.mostSpent,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.black,
              ),
              child: Text(
                strings.viewCategories,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ..._viewModel.categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 21),
            child: _ExpenseCategoryItem(
              name: _getCategoryName(
                strings,
                category.type,
              ),
              percentage: category.percentage,
              amount: _formatCurrency(
                context,
                category.amount,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    final strings = AppLocalizations.of(context)!;

    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: strings.navHome,
              selected: _viewModel.selectedIndex == 0,
              onTap: () => _onNavigationTap(0),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.north_east_rounded,
              activeIcon: Icons.north_east_rounded,
              label: strings.navMovements,
              selected: _viewModel.selectedIndex == 1,
              onTap: () => _onNavigationTap(1),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.credit_card_outlined,
              activeIcon: Icons.credit_card_rounded,
              label: strings.navCards,
              selected: _viewModel.selectedIndex == 2,
              onTap: () => _onNavigationTap(2),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.tune_rounded,
              activeIcon: Icons.tune_rounded,
              label: strings.navProfile,
              selected: _viewModel.selectedIndex == 3,
              onTap: () => _onNavigationTap(3),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyFlowChartPainter extends CustomPainter {
  WeeklyFlowChartPainter({
    required this.expenses,
    required this.incomes,
  });

  final List<double> expenses;
  final List<double> incomes;

  @override
  void paint(Canvas canvas, Size size) {
    final expensesPaint = Paint()
      ..color = const Color(0xFFED4B50)
      ..style = PaintingStyle.fill;

    final incomesPaint = Paint()
      ..color = const Color(0xFF75D449)
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );

    const chartTop = 2.0;
    final chartBottom = size.height - 20;
    final chartHeight = chartBottom - chartTop;
    final groupWidth = size.width / 7;

    const barWidth = 17.0;
    const barGap = 0.0;

    canvas.drawLine(
      Offset(0, chartBottom),
      Offset(size.width, chartBottom),
      axisPaint,
    );

    for (int i = 0; i < 7; i++) {
      final centerX = groupWidth * i + groupWidth / 2;

      final expenseHeight =
          chartHeight * expenses[i];

      final incomeHeight =
          chartHeight * incomes[i];

      final expenseRect = Rect.fromLTWH(
        centerX - barWidth,
        chartBottom - expenseHeight,
        barWidth,
        expenseHeight,
      );

      final incomeRect = Rect.fromLTWH(
        centerX + barGap,
        chartBottom - incomeHeight,
        barWidth,
        incomeHeight,
      );

      canvas.drawRect(expenseRect, expensesPaint);
      canvas.drawRect(incomeRect, incomesPaint);

      textPainter.text = TextSpan(
        text: '${i + 1}',
        style: GoogleFonts.inter(
          color: const Color(0xFFAAAAAA),
          fontSize: 8,
          fontWeight: FontWeight.w400,
        ),
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          chartBottom + 6,
        ),
      );
    }

    final patternPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 0.8;

    for (int i = 0; i < 7; i++) {
      final centerX = groupWidth * i + groupWidth / 2;

      final incomeHeight =
          chartHeight * incomes[i];

      final left = centerX + barGap;
      final top = chartBottom - incomeHeight;

      for (
        double y = top + 6;
        y < chartBottom;
        y += 8
      ) {
        canvas.drawLine(
          Offset(left + 5, y),
          Offset(left + 8, y + 3),
          patternPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant WeeklyFlowChartPainter oldDelegate,
  ) {
    return oldDelegate.expenses != expenses ||
        oldDelegate.incomes != incomes;
  }
}

class _ExpenseCategoryItem extends StatelessWidget {
  const _ExpenseCategoryItem({
    required this.name,
    required this.percentage,
    required this.amount,
  });

  final String name;
  final double percentage;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final percentageText =
        '${(percentage * 100).round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.inter(
                color: const Color(0xFF777777),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 34,
              child: Text(
                percentageText,
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor:
                const Color(0xFFE2E2E2),
            valueColor:
                const AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              size: 18,
              color: selected
                  ? Colors.black
                  : const Color(0xFFA7A7A7),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: selected
                    ? Colors.black
                    : const Color(0xFFA7A7A7),
                fontSize: 7,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthOption extends StatelessWidget {
  const _MonthOption({
    required this.month,
    required this.selected,
    required this.onTap,
  });

  final String month;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        month,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14,
          fontWeight: selected
              ? FontWeight.w600
              : FontWeight.w400,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check,
              color: Colors.black,
            )
          : null,
    );
  }
}