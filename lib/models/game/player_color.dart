import 'package:flutter/material.dart';

enum PlayerColor {
  blue,
  red;

  String get displayName => switch (this) {
    PlayerColor.blue => '青',
    PlayerColor.red => '赤',
  };

  PlayerColor get opponent => switch (this) {
    PlayerColor.blue => PlayerColor.red,
    PlayerColor.red => PlayerColor.blue,
  };

  Color get color => switch (this) {
    PlayerColor.blue => const Color(0xFFBBDEFB), // Pastel Blue (Blue 100)
    PlayerColor.red => const Color(0xFFFFCDD2), // Pastel Red (Red 100)
  };

  Color get darkColor => switch (this) {
    PlayerColor.blue => const Color(0xFF1976D2), // Darker Blue
    PlayerColor.red => const Color(0xFFD32F2F), // Darker Red
  };
}
