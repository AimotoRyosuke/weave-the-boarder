import 'package:flutter/foundation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/services/game/area_detector.dart';

@immutable
class ScoreDetail {
  const ScoreDetail({
    required this.territoryCount,
    required this.completedAreas,
    required this.energy,
  });

  final int territoryCount;
  final int completedAreas;
  final int energy;

  int get total =>
      territoryCount + completedAreas * GameConstants.areaBonusScore + energy;
}

@immutable
class ScoreResult {
  const ScoreResult({required this.white, required this.black});

  final ScoreDetail white;
  final ScoreDetail black;
}

class ScoreCalculator {
  const ScoreCalculator([this.areaDetector = const AreaDetector()]);

  final AreaDetector areaDetector;

  Map<PlayerColor, ScoreDetail> evaluate(GameState state) {
    return {
      PlayerColor.white: _evaluateFor(state, PlayerColor.white),
      PlayerColor.black: _evaluateFor(state, PlayerColor.black),
    };
  }

  ScoreDetail _evaluateFor(GameState state, PlayerColor color) {
    final territory = state.board.cells
        .where((cell) => cell.owner == color)
        .length;
    final areas = areaDetector.detectConnectedAreas(state.board, color);
    final completedAreas = areas
        .where((area) => areaDetector.isFullyEnclosed(state.board, area))
        .length;
    final energy = state.player(color).energy;

    return ScoreDetail(
      territoryCount: territory,
      completedAreas: completedAreas,
      energy: energy,
    );
  }

  PlayerColor? winner(GameState state) {
    final scores = evaluate(state);
    final whiteTotal = scores[PlayerColor.white]!.total;
    final blackTotal = scores[PlayerColor.black]!.total;
    if (whiteTotal == blackTotal) {
      return null;
    }
    return whiteTotal > blackTotal ? PlayerColor.white : PlayerColor.black;
  }
}
