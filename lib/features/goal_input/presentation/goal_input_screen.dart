import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/goal_input/application/goal_list_notifier.dart';

class GoalInputScreen extends ConsumerWidget {
  const GoalInputScreen({super.key});

  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('목표 입력'),
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(
              child: Text('목표를 추가해주세요'),
            );
          }
          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return ListTile(
                title: Text(goal.title),
              );
            },
          );
        },
      ),
    );
  }
}
