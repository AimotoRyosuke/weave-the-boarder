import 'package:flutter/foundation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';

@immutable
class ScoreDetail {
  const ScoreDetail({required this.territoryCount});

  final int territoryCount;

  int get total => territoryCount;
}

@immutable
class ScoreResult {
  const ScoreResult({required this.blue, required this.red});

  final ScoreDetail blue;
  final ScoreDetail red;
}

class ScoreCalculator {
  const ScoreCalculator();

  Map<PlayerColor, ScoreDetail> evaluate(GameState state) {
    return {
      PlayerColor.blue: _evaluateFor(state, PlayerColor.blue),
      PlayerColor.red: _evaluateFor(state, PlayerColor.red),
    };
  }

  ScoreDetail _evaluateFor(GameState state, PlayerColor color) {
    final territory = state.board.cells
        .where((cell) => cell.owner == color)
        .length;

    return ScoreDetail(territoryCount: territory);
  }

  PlayerColor? winner(GameState state) {
    final scores = evaluate(state);
    if (scores[PlayerColor.blue]!.territoryCount >= GameConstants.cellsToWin) {
      return PlayerColor.blue;
    }
    if (scores[PlayerColor.red]!.territoryCount >= GameConstants.cellsToWin) {
      return PlayerColor.red;
    }
    return null;
  }
}
