import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  void _showMonthSelector(AppLocalizations strings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
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
                strings.selectMonth,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _MonthOption(
                month: '${strings.monthJuly} 2026',
                selected: true,
                onTap: () => Navigator.pop(context),
              ),
              _MonthOption(
                month: '${strings.monthJune} 2026',
                selected: false,
                onTap: () => Navigator.pop(context),
              ),
              _MonthOption(
                month: '${strings.monthMay} 2026',
                selected: false,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(strings),
              const SizedBox(height: 28),
              _buildHeading(strings),
              const SizedBox(height: 24),
              _buildBalanceCard(strings),
              const SizedBox(height: 30),
              _buildChartSection(strings),
              const SizedBox(height: 32),
              _buildMostSpentSection(strings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations strings) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _CircleButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.maybePop(context),
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
            child: _CircleButton(
              icon: Icons.keyboard_arrow_down,
              onPressed: () => _showMonthSelector(strings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(AppLocalizations strings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${strings.monthJuly.toUpperCase()} 2026',
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

  Widget _buildBalanceCard(AppLocalizations strings) {
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
            '+\$1.240.000',
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
            strings.balanceMoreThanMonth(18, strings.monthJune.toLowerCase()),
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

  Widget _buildChartSection(AppLocalizations strings) {
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
          child: CustomPaint(painter: WeeklyFlowChartPainter()),
        ),
      ],
    );
  }

  Widget _buildMostSpentSection(AppLocalizations strings) {
    final categories = [
      _ExpenseCategory(
        name: strings.expenseCategoryShopping,
        percentage: 0.32,
        amount: '\$280.000',
      ),
      _ExpenseCategory(
        name: strings.expenseCategoryHousing,
        percentage: 0.27,
        amount: '\$235.000',
      ),
      _ExpenseCategory(
        name: strings.expenseCategoryFood,
        percentage: 0.18,
        amount: '\$157.000',
      ),
      _ExpenseCategory(
        name: strings.expenseCategoryTransport,
        percentage: 0.12,
        amount: '\$104.000',
      ),
      _ExpenseCategory(
        name: strings.expenseCategoryServices,
        percentage: 0.07,
        amount: '\$61.000',
      ),
      _ExpenseCategory(
        name: strings.expenseCategoryEntertainment,
        percentage: 0.04,
        amount: '\$35.000',
      ),
    ];

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
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

        ...categories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(bottom: 21),
            child: _ExpenseCategoryItem(category: category),
          ),
        ),
      ],
    );
  }
}

class WeeklyFlowChartPainter extends CustomPainter {
  final List<double> expenses = const [0.42, 0, 0.13, 0.20, 0.23, 0.25, 0.28];

  final List<double> incomes = const [0.96, 0.56, 0.30, 0.26, 0.51, 0.33, 0.24];

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
      ..color = Colors.white.withOpacity(0.14)
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

class _ExpenseCategory {
  const _ExpenseCategory({
    required this.name,
    required this.percentage,
    required this.amount,
  });

  final String name;
  final double percentage;
  final String amount;
}

class _ExpenseCategoryItem extends StatelessWidget {
  const _ExpenseCategoryItem({required this.category});

  final _ExpenseCategory category;

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

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE4E4E4)),
        ),
        child: Icon(icon, color: Colors.black, size: 19),
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
