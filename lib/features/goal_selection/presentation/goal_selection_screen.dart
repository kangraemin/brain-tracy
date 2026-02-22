import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/goal_selection/application/goal_selection_notifier.dart';

class GoalSelectionScreen extends ConsumerWidget {
  const GoalSelectionScreen({super.key});

  static const routePath = '/goal-selection';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionAsync = ref.watch(goalSelectionNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('핵심 목표 선택'),
      ),
      body: selectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
        data: (selectionState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '24시간 안에 단 하나의 목표만\n이룰 수 있다면?',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: selectionState.goals.length,
                  itemBuilder: (context, index) {
                    final goal = selectionState.goals[index];
                    final isSelected =
                        goal.id == selectionState.selectedGoalId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          leading: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                )
                              : Icon(
                                  Icons.circle_outlined,
                                  color: theme.colorScheme.outline,
                                ),
                          title: Text(
                            goal.title,
                            style: isSelected
                                ? TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        theme.colorScheme.onPrimaryContainer,
                                  )
                                : null,
                          ),
                          onTap: () {
                            ref
                                .read(goalSelectionNotifierProvider.notifier)
                                .selectGoal(goal.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
