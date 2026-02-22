import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:brain_tracy/features/goal_input/application/goal_providers.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';
import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';

const _uuid = Uuid();

class GoalListNotifier extends AsyncNotifier<List<GoalEntity>> {
  GoalRepository get _repository => ref.read(goalRepositoryProvider);

  @override
  FutureOr<List<GoalEntity>> build() {
    return _repository.getAll();
  }

  Future<void> addGoal(String title) async {
    final goal = GoalEntity(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    await _repository.add(goal);
    state = AsyncData(await _repository.getAll());
  }

  Future<void> deleteGoal(String id) async {
    await _repository.delete(id);
    state = AsyncData(await _repository.getAll());
  }

  Future<void> updateGoal(GoalEntity goal) async {
    await _repository.update(goal);
    state = AsyncData(await _repository.getAll());
  }
}

final goalListNotifierProvider =
    AsyncNotifierProvider<GoalListNotifier, List<GoalEntity>>(
  GoalListNotifier.new,
);
