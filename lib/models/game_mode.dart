import 'package:flutter/cupertino.dart';

/// 選択カードの遷移先を識別する列挙型。
enum GameMode {
  local,
  online;

  String get title {
    switch (this) {
      case local:
        return 'ローカル対戦';
      case online:
        return 'オンライン対戦';
    }
  }

  String get description {
    switch (this) {
      case local:
        return '1台の端末で2人プレイするモード。';
      case online:
        return 'Firebase と同期して遠隔のプレイヤーと対戦。';
    }
  }

  IconData get icon {
    switch (this) {
      case local:
        return CupertinoIcons.shield;
      case online:
        return CupertinoIcons.sparkles;
    }
  }

  Color get accentColor {
    switch (this) {
      case local:
        return const Color(0xFF5BB4FF);
      case online:
        return const Color(0xFFF76B7E);
    }
  }
}
