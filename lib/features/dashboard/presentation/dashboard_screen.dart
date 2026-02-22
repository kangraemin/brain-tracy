import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/action_plan/application/action_plan_notifier.dart';
import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';
import 'package:brain_tracy/features/dashboard/application/dashboard_notifier.dart';
import 'package:brain_tracy/features/dashboard/presentation/widgets/progress_ring_painter.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';

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
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('오류가 발생했습니다: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(dashboardNotifierProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
          data: (state) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardNotifierProvider);
            },
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                _buildProfileSection(context, colorScheme),
                const SizedBox(height: 16),
                _buildHeroGoalCard(context, state.selectedGoal, colorScheme),
                const SizedBox(height: 16),
                _buildMetricsRow(context, state, colorScheme),
                const SizedBox(height: 24),
                _buildTodoSection(context, ref, state, colorScheme),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/goal-input');
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.edit, size: 24),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Center(
              child: Text(
                'BT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Text(
                  'Brain Tracy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Notification button
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroGoalCard(
    BuildContext context,
    GoalEntity? selectedGoal,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative blob
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Priority badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Top Priority',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Goal title
                Text(
                  selectedGoal?.title ?? '목표를 설정해주세요',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Quote
                Text(
                  '"Success is a learnable skill."',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                // View Details
                if (selectedGoal != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/action-plan/${selectedGoal.id}',
                        );
                      },
                      icon: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: const Icon(Icons.arrow_forward, size: 18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(
    BuildContext context,
    DashboardState state,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Progress Ring Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CustomPaint(
                      painter: ProgressRingPainter(
                        progress: state.progressPercent,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        progressColor: colorScheme.primary,
                      ),
                      child: Center(
                        child: Text(
                          '${state.progressPercent.round()}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Action Plan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Streak Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      size: 36,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${state.streakDays} ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: 'Days',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Consistency Streak',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
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

  Widget _buildTodoSection(
    BuildContext context,
    WidgetRef ref,
    DashboardState state,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '오늘 할 일',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(To-do Today)',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (state.selectedGoal != null) {
                    Navigator.of(context).pushNamed(
                      '/action-plan/${state.selectedGoal!.id}',
                    );
                  }
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Action steps list
        if (state.actionSteps.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Center(
              child: Text(
                '실행 계획이 없습니다',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...state.actionSteps.map(
            (step) => _buildTodoItem(context, ref, step, state, colorScheme),
          ),
      ],
    );
  }

  Widget _buildTodoItem(
    BuildContext context,
    WidgetRef ref,
    ActionStepEntity step,
    DashboardState state,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        if (state.selectedGoal != null) {
          ref
              .read(
                  actionPlanNotifierProvider(state.selectedGoal!.id).notifier)
              .toggleComplete(step.id);
          ref.invalidate(dashboardNotifierProvider);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: const Offset(0, 1),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.isCompleted
                    ? colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: step.isCompleted
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: step.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Text(
                step.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      step.isCompleted ? FontWeight.normal : FontWeight.w500,
                  decoration:
                      step.isCompleted ? TextDecoration.lineThrough : null,
                  color: step.isCompleted
                      ? colorScheme.onSurface.withValues(alpha: 0.5)
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
