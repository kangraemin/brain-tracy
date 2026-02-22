import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/action_plan/application/action_plan_notifier.dart';
import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';
import 'package:brain_tracy/features/dashboard/presentation/dashboard_screen.dart';
import 'package:brain_tracy/features/goal_input/application/goal_providers.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';
import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'ACTION PLAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: stepsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('오류가 발생했습니다: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(
                            actionPlanNotifierProvider(widget.goalId)),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
                data: (steps) {
                  final completedSteps =
                      steps.where((s) => s.isCompleted).toList();
                  final pendingSteps =
                      steps.where((s) => !s.isCompleted).toList();
                  final completedCount = completedSteps.length;
                  final totalCount = steps.length;
                  final progress =
                      totalCount > 0 ? completedCount / totalCount : 0.0;

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      // Hero Card
                      _buildHeroCard(
                        context,
                        repository: repository,
                        completedCount: completedCount,
                        totalCount: totalCount,
                        progress: progress,
                        colorScheme: colorScheme,
                      ),

                      const SizedBox(height: 20),

                      // Input Field
                      _buildInputField(
                        colorScheme: colorScheme,
                        canAdd: canAdd,
                      ),

                      const SizedBox(height: 24),

                      // NEXT STEPS section
                      if (pendingSteps.isNotEmpty) ...[
                        _buildSectionHeader(
                          'NEXT STEPS',
                          colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        ...pendingSteps.map((step) => _buildStepItem(
                              context,
                              step: step,
                              isCompleted: false,
                              colorScheme: colorScheme,
                            )),
                      ],

                      // Empty state
                      if (steps.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Text(
                              '실행 계획을 추가해주세요',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),

                      // COMPLETED section
                      if (completedSteps.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'COMPLETED',
                          colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        ...completedSteps.map((step) => _buildStepItem(
                              context,
                              step: step,
                              isCompleted: true,
                              colorScheme: colorScheme,
                            )),
                      ],
                    ],
                  );
                },
              ),
            ),

            // Dashboard button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => context.go(DashboardScreen.routePath),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('대시보드 보기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context, {
    required GoalRepository repository,
    required int completedCount,
    required int totalCount,
    required double progress,
    required ColorScheme colorScheme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.edit_note,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),

          // Goal title
          FutureBuilder<List<GoalEntity>>(
            future: repository.getAll(),
            builder: (context, snapshot) {
              final goals = snapshot.data;
              String title = '실행 계획';
              if (goals != null) {
                final goal = goals
                    .where((g) => g.id == widget.goalId)
                    .firstOrNull;
                if (goal != null) title = goal.title;
              }
              return Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Progress info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount OF $totalCount STEPS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '${(progress * 100).round()}% Complete',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Fill
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quote
          Text(
            '"The only way to do great work is to love what you do."',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required ColorScheme colorScheme,
    required bool canAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 1),
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onSubmitted: (_) => _addStep(),
          decoration: InputDecoration(
            hintText: "What's your next step?",
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: InputBorder.none,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: canAdd ? _addStep : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        canAdd ? colorScheme.primary : colorScheme.outline,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required ActionStepEntity step,
    required bool isCompleted,
    required ColorScheme colorScheme,
  }) {
    final child = GestureDetector(
      onTap: () {
        ref
            .read(actionPlanNotifierProvider(widget.goalId).notifier)
            .toggleComplete(step.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isCompleted
              ? colorScheme.surfaceContainerLow
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isCompleted
              ? null
              : [
                  BoxShadow(
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                    color: Colors.black.withValues(alpha: 0.04),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Circular checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                step.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isCompleted ? FontWeight.normal : FontWeight.w500,
                  decoration:
                      isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted
                      ? colorScheme.onSurface.withValues(alpha: 0.5)
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Dismissible(
      key: ValueKey(step.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      onDismissed: (_) {
        ref
            .read(actionPlanNotifierProvider(widget.goalId).notifier)
            .deleteStep(step.id);
      },
      child: child,
    );
  }
}
