/// ゲーム全体で共有する定数群。
abstract class GameConstants {
  GameConstants._();

  static const int boardSize = 7;
  static const int cellsToWin = 15;
  static const int shortWallTokensPerPlayer = 5;
  static const int longWallTokensPerPlayer = 5;
  static const int initialCenterEnergy = 5;
  static const int actionsPerTurn = 1;
}
