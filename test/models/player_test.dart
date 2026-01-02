import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('Player', () {
    test('所持情報と JSON 変換', () {
      final player = Player(
        color: PlayerColor.white,
        piecePosition: Position(row: 0, col: 0),
      );
      final restored = Player.fromJson(player.toJson());

      expect(player.isOnBoard, isTrue);
      expect(player.remainingBorders, GameConstants.borderTokensPerPlayer);
      expect(restored, equals(player));
    });
  });
}
