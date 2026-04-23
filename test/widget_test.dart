import 'package:flutter_test/flutter_test.dart';
import 'package:smarthealth/main.dart';

void main() {
  testWidgets('SmartHealth app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartHealthApp());
    expect(find.byType(SmartHealthApp), findsOneWidget);
  });
}
