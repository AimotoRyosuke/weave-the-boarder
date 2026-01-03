import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('Board', () {
    test('初期状態のボードを構築できる', () {
      final board = Board.initial(seed: 42);

      expect(
        board.cells,
        hasLength(GameConstants.boardSize * GameConstants.boardSize),
      );
      expect(board.energyStacks, hasLength(5));
      expect(
        board.cellAt(const Position(row: 6, col: 3)).owner,
        equals(PlayerColor.blue),
      );
      expect(
        board.cellAt(const Position(row: 0, col: 3)).owner,
        equals(PlayerColor.red),
      );
    });

    test('セルやスタックの取得と例外処理', () {
      final board = Board.initial();
      final missingPosition = const Position(row: -1, col: 0);
      final emptyPosition = const Position(
        row: 1,
        col: 0,
      ); // row 1 never has energy initially

      expect(() => board.cellAt(missingPosition), throwsRangeError);
      expect(board.hasEnergyAt(emptyPosition), isFalse);
    });
  });
}
