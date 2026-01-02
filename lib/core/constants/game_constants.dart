/// ゲーム全体で共有する定数群。
abstract class GameConstants {
  GameConstants._();

  static const int boardSize = 5;
  static const int borderTokensPerPlayer = 10;
  static const int maxEnergyTokens = 5;
  static const int initialCenterEnergy = 3;
  static const int areaBonusScore = 3;
}
