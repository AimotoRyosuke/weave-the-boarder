import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('Board', () {
    test('初期状態のボードを構築できる', () {
      final board = Board.initial();
      final center = Position(
        row: GameConstants.boardSize ~/ 2,
        col: GameConstants.boardSize ~/ 2,
      );

      expect(
        board.cells,
        hasLength(GameConstants.boardSize * GameConstants.boardSize),
      );
      expect(board.energyStacks, hasLength(1));
      expect(board.hasEnergyAt(center), isTrue);
      expect(
        board.cellAt(Position(row: 0, col: 0)).owner,
        equals(PlayerColor.white),
      );
      expect(
        board
            .cellAt(
              Position(
                row: GameConstants.boardSize - 1,
                col: GameConstants.boardSize - 1,
              ),
            )
            .owner,
        equals(PlayerColor.black),
      );
    });

    test('セルやスタックの取得と例外処理', () {
      final board = Board.initial();
      final missingPosition = Position(row: -1, col: 0);
      final emptyPosition = Position(row: 0, col: 1);

      expect(() => board.cellAt(missingPosition), throwsRangeError);
      expect(board.stackAt(emptyPosition).count, 0);
      expect(board.hasEnergyAt(emptyPosition), isFalse);
    });
  });
}
