import 'package:flutter_test/flutter_test.dart';
import 'package:routecash/main.dart';

void main() {
  testWidgets('Muestra la pantalla inicial de RouteCash', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RouteCashApp());

    expect(find.text('RouteCash'), findsOneWidget);
    expect(find.text('Tus finanzas en un solo lugar'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
