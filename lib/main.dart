import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/app.dart';
import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/action_plan/infrastructure/action_step_hive_model.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_hive_model.dart';
import 'package:brain_tracy/features/dashboard/infrastructure/user_activity_hive_model.dart';
import 'package:brain_tracy/features/onboarding/infrastructure/settings_hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();

  runApp(
    const ProviderScope(
      child: BrainTracyApp(),
    ),
  );
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  _registerAdapters();

  try {
    await _openBoxes();
  } catch (_) {
    // Hive 박스 손상 시 삭제 후 재생성
    await Hive.deleteFromDisk();
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(GoalHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ActionStepHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(SettingsHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(UserActivityHiveModelAdapter());
  }
}

Future<void> _openBoxes() async {
  await Future.wait([
    Hive.openBox<GoalHiveModel>(HiveConstants.goalBox),
    Hive.openBox<ActionStepHiveModel>(HiveConstants.actionPlanBox),
    Hive.openBox<SettingsHiveModel>(HiveConstants.settingsBox),
    Hive.openBox<UserActivityHiveModel>(HiveConstants.userActivityBox),
  ]);
}
