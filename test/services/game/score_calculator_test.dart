import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';

void main() {
  group('スコア計算', () {
    test('初期状態は自分の領域だけがスコアになる', () {
      final state = GameState.initial();
      final result = const ScoreCalculator().evaluate(state);

      expect(result[PlayerColor.blue]?.territoryCount, equals(1));
      expect(result[PlayerColor.blue]?.total, equals(1));
      expect(result[PlayerColor.red]?.territoryCount, equals(1));
      expect(result[PlayerColor.red]?.total, equals(1));
    });

    test('領域数が合計スコアになる', () {
      final base = GameState.initial();
      final areaCells = {
        const Position(row: 1, col: 1),
        const Position(row: 1, col: 2),
      };
      final updatedCells = base.board.cells.map((cell) {
        if (areaCells.contains(cell.position)) {
          return cell.copyWith(owner: PlayerColor.blue);
        }
        return cell;
      }).toList();

      final bordered = base.board.copyWith(cells: updatedCells);

      final customState = base.copyWith(board: bordered);

      final result = const ScoreCalculator().evaluate(customState);
      final blueScore = result[PlayerColor.blue]!;

      expect(blueScore.territoryCount, equals(3)); // Initial 1 + 2 new
      expect(blueScore.total, equals(3));
    });

    test('15マス到達で勝利判定', () {
      final base = GameState.initial();
      final calculator = const ScoreCalculator();

      expect(calculator.winner(base), isNull);

      final winningCells = List.generate(
        15,
        (i) => Position(row: i ~/ 7, col: i % 7),
      );
      final updatedCells = base.board.cells.map((cell) {
        if (winningCells.contains(cell.position)) {
          return cell.copyWith(owner: PlayerColor.blue);
        }
        return cell;
      }).toList();

      final winningState = base.copyWith(
        board: base.board.copyWith(cells: updatedCells),
      );

      expect(calculator.winner(winningState), equals(PlayerColor.blue));
    });
  });
}
