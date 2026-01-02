import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  test('初期状態で2人のプレイヤーと中央にエネルギーが配置される', () {
    final gameState = GameState.initial();
    final center = Position(
      row: GameConstants.boardSize ~/ 2,
      col: GameConstants.boardSize ~/ 2,
    );

    expect(gameState.players, hasLength(2));
    expect(gameState.activePlayer.color, PlayerColor.white);
    expect(gameState.waitingPlayer.color, PlayerColor.black);
    expect(
      gameState.board.energyStacks.any(
        (stack) =>
            stack.position == center &&
            stack.count == GameConstants.initialCenterEnergy,
      ),
      isTrue,
    );
    expect(
      gameState.board.cells.where((cell) => cell.owner != null),
      hasLength(2),
    );
    expect(
      gameState.board.cellAt(gameState.activePlayer.piecePosition).owner,
      equals(PlayerColor.white),
    );
    expect(
      gameState.board.cellAt(gameState.waitingPlayer.piecePosition).owner,
      equals(PlayerColor.black),
    );
  });

  test('JSON化→復元で元の状態に戻る', () {
    final gameState = GameState.initial();
    final json = gameState.toJson();
    final restored = GameState.fromJson(json);
    expect(restored.toJson(), equals(gameState.toJson()));
  });
}
