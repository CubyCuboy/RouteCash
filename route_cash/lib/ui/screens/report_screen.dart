import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/expense_category.dart';
import '../../utils/currency_formatter.dart';
import '../../viewmodels/report_view_model.dart';
import '../components/route_cash_buttons.dart';

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

  void _showMonthSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
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
                    'Seleccionar mes',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._viewModel.months.map((month) {
                    return _MonthOption(
                      month: month,
                      selected: _viewModel.selectedMonth == month,
                      onTap: () {
                        _viewModel.selectMonth(month);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
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
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
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
            'Reporte',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _viewModel.selectedMonth.toUpperCase(),
            style: GoogleFonts.inter(
              color: const Color(0xFF9A9A9A),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            'Tu mes en cifras.',
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
    return Container(
      width: double.infinity,
      height: 132,
      padding: const EdgeInsets.fromLTRB(19, 20, 19, 18),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BALANCE MENSUAL',
            style: GoogleFonts.inter(
              color: const Color(0xFF909090),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 19),
          Text(
            CurrencyFormatter.format(_viewModel.monthlyBalance, showSign: true),
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
            _viewModel.balanceComparison,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Flujo semanal',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'Gastos / Ingresos',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Más gastado',
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
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.black,
              ),
              child: Text(
                'Ver categorías',
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
        ..._viewModel.categories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(bottom: 21),
            child: _ExpenseCategoryItem(category: category),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 62,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Inicio',
              selected: _viewModel.selectedIndex == 0,
              onTap: () => _onNavigationTap(0),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.north_east,
              activeIcon: Icons.north_east,
              label: 'Movimientos',
              selected: _viewModel.selectedIndex == 1,
              onTap: () => _onNavigationTap(1),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.credit_card_outlined,
              activeIcon: Icons.credit_card,
              label: 'Tarjetas',
              selected: _viewModel.selectedIndex == 2,
              onTap: () => _onNavigationTap(2),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.tune,
              activeIcon: Icons.tune,
              label: 'Perfil',
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

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

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

      final expenseHeight = chartHeight * expenses[i];
      final incomeHeight = chartHeight * incomes[i];

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
        Offset(centerX - textPainter.width / 2, chartBottom + 6),
      );
    }

    final patternPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 0.8;

    for (int i = 0; i < 7; i++) {
      final centerX = groupWidth * i + groupWidth / 2;
      final incomeHeight = chartHeight * incomes[i];
      final left = centerX + barGap;
      final top = chartBottom - incomeHeight;

      for (double y = top + 6; y < chartBottom; y += 8) {
        canvas.drawLine(
          Offset(left + 5, y),
          Offset(left + 8, y + 3),
          patternPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ExpenseCategoryItem extends StatelessWidget {
  const _ExpenseCategoryItem({required this.category});

  final ExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    final percentageText = '${(category.percentage * 100).round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              category.amount,
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
            value: category.percentage,
            minHeight: 6,
            backgroundColor: const Color(0xFFE2E2E2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
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
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              size: 18,
              color: selected ? Colors.black : const Color(0xFFA7A7A7),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: selected ? Colors.black : const Color(0xFFA7A7A7),
                fontSize: 7,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: selected ? const Icon(Icons.check, color: Colors.black) : null,
    );
  }
}
