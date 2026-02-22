import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/app.dart';

void main() {
  testWidgets('앱 시작 스모크 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BrainTracyApp(),
      ),
    );

    expect(find.text('Brain Tracy'), findsWidgets);
  });
}
