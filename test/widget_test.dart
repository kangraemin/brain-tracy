import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('앱 시작 스모크 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Brain Tracy'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Brain Tracy'), findsOneWidget);
  });
}
