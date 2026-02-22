import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/app.dart';
import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GoalHiveModelAdapter());
  await Hive.openBox<GoalHiveModel>(HiveConstants.goalBox);

  runApp(
    const ProviderScope(
      child: BrainTracyApp(),
    ),
  );
}
