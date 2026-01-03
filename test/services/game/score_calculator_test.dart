import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';

void main() {
  group('スコア計算', () {
    test('初期状態は自分の領域だけがスコアになる', () {
      final state = GameState.initial();
      final result = const ScoreCalculator().evaluate(state);

      expect(result[PlayerColor.white]?.territoryCount, equals(1));
      expect(result[PlayerColor.white]?.completedAreas, equals(0));
      expect(result[PlayerColor.white]?.energy, equals(0));
      expect(result[PlayerColor.white]?.total, equals(1));
      expect(result[PlayerColor.black]?.total, equals(1));
    });

    test('囲まれたエリアとエネルギーが合計スコアに加算される', () {
      final base = GameState.initial();
      final areaCells = {
        const Position(row: 1, col: 1),
        const Position(row: 1, col: 2),
      };
      final updatedCells = base.board.cells.map((cell) {
        if (areaCells.contains(cell.position)) {
          return cell.copyWith(owner: PlayerColor.white);
        }
        return cell;
      }).toList();

      final bordered = base.board.copyWith(
        cells: updatedCells,
        borders: [
          BorderEdge(
            anchor: const Position(row: 1, col: 1),
            orientation: BorderOrientation.left,
            owner: PlayerColor.white,
          ),
          BorderEdge(
            anchor: const Position(row: 1, col: 1),
            orientation: BorderOrientation.top,
            owner: PlayerColor.white,
          ),
          BorderEdge(
            anchor: const Position(row: 1, col: 1),
            orientation: BorderOrientation.bottom,
            owner: PlayerColor.white,
          ),
          BorderEdge(
            anchor: const Position(row: 1, col: 2),
            orientation: BorderOrientation.top,
            owner: PlayerColor.white,
          ),
          BorderEdge(
            anchor: const Position(row: 1, col: 2),
            orientation: BorderOrientation.right,
            owner: PlayerColor.white,
          ),
          BorderEdge(
            anchor: const Position(row: 1, col: 2),
            orientation: BorderOrientation.bottom,
            owner: PlayerColor.white,
          ),
        ],
      );

      final updatedPlayers = base.players.map((player) {
        if (player.color == PlayerColor.white) {
          return player.copyWith(energy: 2);
        }
        return player;
      }).toList();

      final customState = base.copyWith(
        board: bordered,
        players: updatedPlayers,
      );

      final result = const ScoreCalculator().evaluate(customState);
      final whiteScore = result[PlayerColor.white]!;

      expect(whiteScore.completedAreas, equals(1));
      expect(whiteScore.energy, equals(2));
      expect(
        whiteScore.total,
        equals(whiteScore.territoryCount + GameConstants.areaBonusScore + 2),
      );
    });
  });
}
