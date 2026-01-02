import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';

void main() {
  group('ゲームルール', () {
    const service = GameRuleService();

    test('駒を隣接マスに移動できる', () {
      final initial = GameState.initial();
      final movedState = service.movePiece(
        initial,
        const Position(row: 1, col: 0),
      );

      expect(
        movedState.activePlayer.piecePosition,
        equals(const Position(row: 1, col: 0)),
      );
      expect(
        movedState.board.cellAt(const Position(row: 1, col: 0)).owner,
        equals(PlayerColor.white),
      );
    });

    test('中央エネルギーを獲得するとスタックが減る', () {
      final initial = GameState.initial();
      final center = const Position(row: 2, col: 2);
      final afterCollect = service.collectEnergy(initial, center);

      expect(afterCollect.activePlayer.energy, equals(1));
      expect(
        afterCollect.board.stackAt(center).count,
        equals(GameConstants.initialCenterEnergy - 1),
      );
    });

    test('特殊移動はエネルギーを消費する', () {
      final initial = GameState.initial();
      final center = const Position(row: 2, col: 2);
      final afterCollect = service.collectEnergy(initial, center);
      final afterSpecial = service.specialMove(
        afterCollect,
        const Position(row: 1, col: 0),
      );

      expect(
        afterSpecial.activePlayer.piecePosition,
        equals(const Position(row: 1, col: 0)),
      );
      expect(afterSpecial.activePlayer.energy, equals(0));
    });

    test('境界を配置するとトークンが減少する', () {
      final initial = GameState.initial();
      final afterBorder = service.placeBorder(
        initial,
        const Position(row: 0, col: 0),
        BorderOrientation.right,
      );

      expect(afterBorder.board.borders, hasLength(1));
      expect(
        afterBorder.activePlayer.remainingBorders,
        equals(GameConstants.borderTokensPerPlayer - 1),
      );
    });

    test('相手の境界を破壊できる', () {
      final base = GameState.initial();
      final enemyBorder = BorderEdge(
        anchor: const Position(row: 4, col: 4),
        orientation: BorderOrientation.left,
        owner: PlayerColor.black,
      );
      final prepared = base.copyWith(
        board: base.board.copyWith(borders: [enemyBorder]),
        players: base.players
            .map(
              (player) => player.color == PlayerColor.white
                  ? player.copyWith(energy: GameRuleService.specialBreakCost)
                  : player,
            )
            .toList(),
      );

      final afterBreak = service.breakBorder(prepared, enemyBorder);

      expect(afterBreak.board.borders, isEmpty);
      expect(afterBreak.activePlayer.energy, equals(0));
    });

    test('要塞化で境界が強化される', () {
      final base = GameState.initial();
      final area = {const Position(row: 0, col: 0)};
      final edges = [
        BorderEdge(
          anchor: const Position(row: 0, col: 0),
          orientation: BorderOrientation.right,
          owner: PlayerColor.white,
        ),
        BorderEdge(
          anchor: const Position(row: 0, col: 0),
          orientation: BorderOrientation.bottom,
          owner: PlayerColor.white,
        ),
      ];
      final prepared = base.copyWith(
        board: base.board.copyWith(borders: edges),
        players: base.players
            .map(
              (player) => player.color == PlayerColor.white
                  ? player.copyWith(energy: GameRuleService.specialFortifyCost)
                  : player,
            )
            .toList(),
      );

      final fortified = service.fortifyArea(prepared, area);

      expect(fortified.board.borders.every((edge) => edge.isFortified), isTrue);
      expect(fortified.activePlayer.energy, equals(0));
    });
  });
}
