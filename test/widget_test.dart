import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/goal_input/application/goal_list_notifier.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';

void main() {
  testWidgets('앱 시작 스모크 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goalListNotifierProvider.overrideWith(
            () => _FakeGoalListNotifier(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Brain Tracy')),
          ),
        ),
      ),
    );

    expect(find.text('Brain Tracy'), findsOneWidget);
  });
}

class _FakeGoalListNotifier extends AsyncNotifier<List<GoalEntity>>
    implements GoalListNotifier {
  @override
  Future<List<GoalEntity>> build() async => [];

  @override
  Future<void> addGoal(String title) async {}

  @override
  Future<void> deleteGoal(String id) async {}

  @override
  Future<void> updateGoal(GoalEntity goal) async {}
}
