import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/data/repositories/settingsRepository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SettingsRepository _settingsRepository;

  ThemeCubit(this._settingsRepository)
      : super(_settingsRepository.getThemeMode());

  /// Cycles system -> light -> dark -> system, which is all a single app-bar
  /// button needs.
  Future<void> toggleThemeMode() async {
    final next = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };

    await _settingsRepository.setThemeMode(next);
    emit(next);
  }
}
