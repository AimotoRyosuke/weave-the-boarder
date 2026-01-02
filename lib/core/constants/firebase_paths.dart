/// Firebase Realtime Database のルートパスを定義。
abstract class FirebasePaths {
  FirebasePaths._();

  /// 部屋を保存するノード
  static const String rooms = 'rooms';

  /// 各部屋のゲーム状態ノード
  static const String gameState = 'gameState';
}
