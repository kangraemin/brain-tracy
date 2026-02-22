import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/action_plan/application/action_plan_notifier.dart';
import 'package:brain_tracy/features/goal_input/application/goal_providers.dart';

class ActionPlanScreen extends ConsumerWidget {
  const ActionPlanScreen({super.key, required this.goalId});

  final String goalId;

  static const routePath = '/action-plan/:goalId';

  static String buildPath(String goalId) => '/action-plan/$goalId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(actionPlanNotifierProvider(goalId));
    final repository = ref.watch(goalRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: repository.getAll(),
          builder: (context, snapshot) {
            final goals = snapshot.data;
            if (goals == null) return const Text('실행 계획');
            final goal = goals.where((g) => g.id == goalId).firstOrNull;
            return Text(goal?.title ?? '실행 계획');
          },
        ),
      ),
      body: stepsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
        data: (steps) {
          if (steps.isEmpty) {
            return const Center(
              child: Text('실행 계획을 추가해주세요'),
            );
          }
          return ListView.builder(
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return ListTile(
                leading: Icon(
                  step.isCompleted
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: step.isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                title: Text(
                  step.title,
                  style: step.isCompleted
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context).colorScheme.outline,
                        )
                      : null,
                ),
                onTap: () {
                  ref
                      .read(actionPlanNotifierProvider(goalId).notifier)
                      .toggleComplete(step.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
