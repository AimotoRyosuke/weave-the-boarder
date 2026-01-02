import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF1D3557);
const Color _accentColor = Color(0xFFEA7C5D);

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    secondary: _accentColor,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF0F5F9),
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _accentColor,
    foregroundColor: Colors.white,
  ),
  textTheme: Typography.material2018().black.apply(bodyColor: Colors.black87),
);
