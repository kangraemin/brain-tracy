import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/action_plan/presentation/action_plan_screen.dart';
import 'package:brain_tracy/features/dashboard/application/dashboard_notifier.dart';
import 'package:brain_tracy/features/dashboard/presentation/widgets/progress_ring_painter.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const routePath = '/dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'DASHBOARD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  // Placeholder for symmetry
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: dashboardAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '오류가 발생했습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$error',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () =>
                              ref.invalidate(dashboardNotifierProvider),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (state) {
                  final goal = state.selectedGoal;

                  if (goal == null) {
                    return _buildEmptyState(context, colorScheme);
                  }

                  return _buildDashboardContent(
                    context,
                    ref: ref,
                    state: state,
                    colorScheme: colorScheme,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flag_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '목표를 설정해보세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '목표를 설정하면 진행 상황과\n실행 계획을 확인할 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context, {
    required WidgetRef ref,
    required DashboardState state,
    required ColorScheme colorScheme,
  }) {
    final goal = state.selectedGoal!;
    final completedCount =
        state.actionSteps.where((s) => s.isCompleted).length;
    final totalCount = state.actionSteps.length;
    final progress =
        totalCount > 0 ? completedCount / totalCount : 0.0;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(dashboardNotifierProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          const SizedBox(height: 8),

          // Streak Card
          _buildStreakCard(
            context,
            streakDays: state.streakDays,
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 20),

          // Selected Goal Card
          _buildGoalCard(
            context,
            goalTitle: goal.title,
            completedCount: completedCount,
            totalCount: totalCount,
            progress: progress,
            progressPercent: state.progressPercent,
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 20),

          // Action Steps Overview
          _buildActionStepsOverview(
            context,
            completedCount: completedCount,
            totalCount: totalCount,
            steps: state.actionSteps
                .map((s) => (title: s.title, isCompleted: s.isCompleted))
                .toList(),
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 24),

          // Quick Action Button
          _buildQuickActionButton(
            context,
            goalId: goal.id,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(
    BuildContext context, {
    required int streakDays,
    required ColorScheme colorScheme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: colorScheme.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Flame icon container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONSISTENCY STREAK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$streakDays',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Days',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context, {
    required String goalTitle,
    required int completedCount,
    required int totalCount,
    required double progress,
    required double progressPercent,
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
          // Section label
          Text(
            'SELECTED GOAL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 12),

          // Goal title
          Text(
            goalTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Progress info row
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
                '${progressPercent.round()}% Complete',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar (same gradient style as ActionPlanScreen)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
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
        ],
      ),
    );
  }

  Widget _buildActionStepsOverview(
    BuildContext context, {
    required int completedCount,
    required int totalCount,
    required List<({String title, bool isCompleted})> steps,
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
          // Section header with progress ring
          Row(
            children: [
              // Mini progress ring
              SizedBox(
                width: 48,
                height: 48,
                child: CustomPaint(
                  painter: ProgressRingPainter(
                    progress: totalCount > 0
                        ? (completedCount / totalCount) * 100
                        : 0,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    progressColor: colorScheme.primary,
                    strokeWidth: 5,
                  ),
                  child: Center(
                    child: Text(
                      '$completedCount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTION STEPS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedCount / $totalCount 완료',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (steps.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Show up to 3 recent steps
            ...steps.take(3).map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: step.isCompleted
                              ? colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: step.isCompleted
                                ? colorScheme.primary
                                : colorScheme.outline
                                    .withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: step.isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: step.isCompleted
                                ? FontWeight.normal
                                : FontWeight.w500,
                            decoration: step.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: step.isCompleted
                                ? colorScheme.onSurface
                                    .withValues(alpha: 0.5)
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            if (steps.length > 3) ...[
              const SizedBox(height: 8),
              Text(
                '+ ${steps.length - 3}개 더',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String goalId,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () =>
              context.push(ActionPlanScreen.buildPath(goalId)),
          icon: const Icon(Icons.checklist_rounded),
          label: const Text(
            '실행 계획 보기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            shadowColor: colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
