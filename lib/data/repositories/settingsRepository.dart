import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsly/utils/hiveBoxKeys.dart';

class SettingsRepository {
  Box get _box => Hive.box(settingsBoxKey);

  ThemeMode getThemeMode() {
    final stored = _box.get(themeModeKey) as String?;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _box.put(themeModeKey, themeMode.name);
  }
}
