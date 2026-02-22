import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/goal_input/application/goal_list_notifier.dart';

class GoalInputScreen extends ConsumerStatefulWidget {
  const GoalInputScreen({super.key});

  static const routePath = '/';

  @override
  ConsumerState<GoalInputScreen> createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends ConsumerState<GoalInputScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addGoal() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    ref.read(goalListNotifierProvider.notifier).addGoal(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('목표 입력'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '목표를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addGoal(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addGoal,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: goalsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
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
          ),
        ],
      ),
    );
  }
}
