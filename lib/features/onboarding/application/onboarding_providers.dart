import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/onboarding/infrastructure/settings_hive_model.dart';

final settingsBoxProvider = Provider<Box<SettingsHiveModel>>((ref) {
  return Hive.box<SettingsHiveModel>(HiveConstants.settingsBox);
});

final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final box = ref.watch(settingsBoxProvider);
  final settings = box.get('default');
  return settings?.hasCompletedOnboarding ?? false;
});

final completeOnboardingProvider = Provider<Future<void> Function()>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return () async {
    await box.put(
      'default',
      SettingsHiveModel(hasCompletedOnboarding: true),
    );
    ref.invalidate(hasCompletedOnboardingProvider);
  };
});
