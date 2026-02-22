import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/goal_input/application/goal_list_notifier.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';
import 'package:brain_tracy/features/goal_selection/presentation/goal_selection_screen.dart';

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

  Future<void> _editGoal(GoalEntity goal) async {
    final editController = TextEditingController(text: goal.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('목표 수정'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '목표를 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, editController.text.trim()),
            child: const Text('저장'),
          ),
        ],
      ),
    );
    editController.dispose();

    if (result != null && result.isNotEmpty && result != goal.title) {
      ref
          .read(goalListNotifierProvider.notifier)
          .updateGoal(goal.copyWith(title: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalListNotifierProvider);
    final goalCount = goalsAsync.valueOrNull?.length ?? 0;
    final canAdd = goalCount < maxGoalCount;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  if (context.canPop())
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      '목표 입력 ($goalCount/$maxGoalCount)',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: goalsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('오류가 발생했습니다: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(goalListNotifierProvider),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
                data: (goals) => ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Input Section
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '새로운 목표 추가',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '내 가장 중요한 목표는...',
                        hintStyle: TextStyle(
                          color:
                              colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: colorScheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: colorScheme.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          onPressed: canAdd ? _addGoal : null,
                          icon: Icon(
                            Icons.add_circle,
                            color: canAdd
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.3),
                            size: 28,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _addGoal(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Text(
                        '현재형으로 작성하세요 (예: 나는 ~한다)',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Goal List or Empty State
                    if (goals.isEmpty)
                      _buildEmptyState(colorScheme)
                    else ...[
                      ...goals.asMap().entries.map((entry) {
                        final index = entry.key;
                        final goal = entry.value;
                        return _buildGoalItem(
                          goal: goal,
                          index: index,
                          colorScheme: colorScheme,
                        );
                      }),
                      if (goalCount < maxGoalCount) ...[
                        const SizedBox(height: 4),
                        _buildRemainingHint(colorScheme, goalCount),
                      ],
                    ],
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.2),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: goalCount > 0
                      ? () => context.push(GoalSelectionScreen.routePath)
                      : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('다음'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem({
    required GoalEntity goal,
    required int index,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(goal.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.delete,
            color: colorScheme.onError,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('목표 삭제'),
                  content:
                      Text('"${goal.title}"을(를) 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              ) ??
              false;
        },
        onDismissed: (_) {
          ref
              .read(goalListNotifierProvider.notifier)
              .deleteGoal(goal.id);
        },
        child: GestureDetector(
          onTap: () => _editGoal(goal),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    goal.title,
                    style:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(goalListNotifierProvider.notifier)
                        .deleteGoal(goal.id);
                  },
                  icon: Icon(
                    Icons.close,
                    color:
                        colorScheme.onSurfaceVariant.withOpacity(0.4),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: colorScheme.primary.withOpacity(0.2),
        borderRadius: 16,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 40,
              color: colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              '목표를 추가해주세요',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemainingHint(ColorScheme colorScheme, int goalCount) {
    final remaining = maxGoalCount - goalCount;
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: 16,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note,
              size: 20,
              color: colorScheme.primary.withOpacity(0.4),
            ),
            const SizedBox(width: 8),
            Text(
              '$remaining개의 목표가 남았습니다',
              style: TextStyle(
                color: colorScheme.primary.withOpacity(0.4),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    const double dashWidth = 6;
    const double dashSpace = 4;

    final dest = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        dest.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dest, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
