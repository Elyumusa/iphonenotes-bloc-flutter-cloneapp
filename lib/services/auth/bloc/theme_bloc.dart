import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../themes/main_theme.dart';

class ThemeBloc extends Bloc<ChangeThemeEvent, ThemeMode> {
  ThemeBloc()
      : super(AppTheme.currentSystemBrightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark) {
    on<ChangeThemeEvent>((event, emit) => emit(event.currentTheme));
  }
  void updateAppTheme() {
    final Brightness currentBrightness = AppTheme.currentSystemBrightness;
    currentBrightness == Brightness.light
        ? setTheme(ThemeMode.light)
        : setTheme(ThemeMode.dark);
  }

  bool currentlyDark = false;
  void setTheme(ThemeMode themeMode) {
    AppTheme.setStatusBarAndNavigationBarColors(themeMode);
    print("set fire: ${themeMode.name}");
    add(ChangeThemeEvent(currentTheme: themeMode));
  }
}

class ChangeThemeEvent {
  ThemeMode currentTheme;
  ChangeThemeEvent({required this.currentTheme});
}
