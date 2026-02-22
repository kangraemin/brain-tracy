import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/action_plan/application/action_plan_notifier.dart';
import 'package:brain_tracy/features/goal_input/application/goal_providers.dart';

class ActionPlanScreen extends ConsumerStatefulWidget {
  const ActionPlanScreen({super.key, required this.goalId});

  final String goalId;

  static const routePath = '/action-plan/:goalId';

  static String buildPath(String goalId) => '/action-plan/$goalId';

  @override
  ConsumerState<ActionPlanScreen> createState() => _ActionPlanScreenState();
}

class _ActionPlanScreenState extends ConsumerState<ActionPlanScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addStep() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    ref
        .read(actionPlanNotifierProvider(widget.goalId).notifier)
        .addStep(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final stepsAsync = ref.watch(actionPlanNotifierProvider(widget.goalId));
    final repository = ref.watch(goalRepositoryProvider);
    final stepCount = stepsAsync.valueOrNull?.length ?? 0;
    final canAdd = stepCount < maxStepCount;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: repository.getAll(),
          builder: (context, snapshot) {
            final goals = snapshot.data;
            if (goals == null) {
              return Text('실행 계획 ($stepCount/$maxStepCount)');
            }
            final goal =
                goals.where((g) => g.id == widget.goalId).firstOrNull;
            return Text(
              '${goal?.title ?? '실행 계획'} ($stepCount/$maxStepCount)',
            );
          },
        ),
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
                      hintText: '실행 계획을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addStep(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: canAdd ? _addStep : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: stepsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
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
                            .read(actionPlanNotifierProvider(widget.goalId)
                                .notifier)
                            .toggleComplete(step.id);
                      },
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
