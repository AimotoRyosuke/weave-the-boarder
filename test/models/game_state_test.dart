import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  test('初期状態で2人のプレイヤーと5つのエナジーが配置される', () {
    final gameState = GameState.initial();

    expect(gameState.players, hasLength(2));
    expect(gameState.activePlayer.color, PlayerColor.blue);
    expect(gameState.waitingPlayer.color, PlayerColor.red);

    expect(gameState.board.energyStacks.length, equals(5));
    expect(
      gameState.board.cells.where((cell) => cell.owner != null),
      hasLength(2),
    );
    expect(
      gameState.board.cellAt(const Position(row: 6, col: 3)).owner,
      equals(PlayerColor.blue),
    );
    expect(
      gameState.board.cellAt(const Position(row: 0, col: 3)).owner,
      equals(PlayerColor.red),
    );
  });

  test('JSON化→復元で元の状態に戻る', () {
    final gameState = GameState.initial();
    final json = gameState.toJson();
    final restored = GameState.fromJson(json);
    expect(restored.toJson(), equals(gameState.toJson()));
  });
}
