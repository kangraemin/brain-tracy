import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/action_plan/presentation/action_plan_screen.dart';
import 'package:brain_tracy/features/goal_selection/application/goal_selection_notifier.dart';

class GoalSelectionScreen extends ConsumerStatefulWidget {
  const GoalSelectionScreen({super.key});

  static const routePath = '/goal-selection';

  @override
  ConsumerState<GoalSelectionScreen> createState() =>
      _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends ConsumerState<GoalSelectionScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  late final AnimationController _badgeController;
  late final Animation<Offset> _badgeSlide;

  String? _previousSelectedId;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseOpacity = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _badgeSlide = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm(String selectedGoalId) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(goalSelectionNotifierProvider.notifier)
          .confirmSelection();
      if (mounted) {
        context.go(ActionPlanScreen.buildPath(selectedGoalId));
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectionAsync = ref.watch(goalSelectionNotifierProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outline;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: selectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('오류가 발생했습니다: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(goalSelectionNotifierProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (selectionState) {
          final hasSelection = selectionState.selectedGoalId != null;

          // Trigger badge animation on selection change
          if (selectionState.selectedGoalId != _previousSelectedId) {
            _previousSelectedId = selectionState.selectedGoalId;
            if (hasSelection) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _badgeController.forward(from: 0);
              });
            }
          }

          return SafeArea(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'STEP 3 OF 5',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 16),
                      // Hero Icon with Pulse
                      Center(
                        child: ScaleTransition(
                          scale: _pulseScale,
                          child: FadeTransition(
                            opacity: _pulseOpacity,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.priority_high,
                                color: primary,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Heading with highlighted text
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              height: 1.3,
                            ),
                            children: [
                              const TextSpan(text: '24시간 안에\n'),
                              TextSpan(
                                text: '단 하나만',
                                style: TextStyle(color: primary),
                              ),
                              const TextSpan(text: ' 이룰 수 있다면?'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        'Select the goal that would have the greatest positive impact on your life right now.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Goal Selection List
                      ...selectionState.goals.map((goal) {
                        final isSelected =
                            goal.id == selectionState.selectedGoalId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    ref
                                        .read(goalSelectionNotifierProvider
                                            .notifier)
                                        .selectGoal(goal.id);
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary.withValues(alpha: 0.05)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? primary
                                      : outline.withValues(alpha: 0.3),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          blurRadius: 8,
                                          color: primary.withValues(alpha: 0.1),
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: AnimatedOpacity(
                                opacity: isSelected
                                    ? 1.0
                                    : (hasSelection ? 0.7 : 1.0),
                                duration: const Duration(milliseconds: 200),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: isSelected ? primary : outline,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            goal.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: theme
                                                  .colorScheme.onSurface,
                                            ),
                                          ),
                                          if (isSelected) ...[
                                            const SizedBox(height: 6),
                                            SlideTransition(
                                              position: _badgeSlide,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFFEADDFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                ),
                                                child: Text(
                                                  'High Impact',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                // Bottom CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: FilledButton(
                    onPressed: hasSelection && !_isLoading
                        ? () =>
                            _onConfirm(selectionState.selectedGoalId!)
                        : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: const StadiumBorder(),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '이 목표에 집중하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
