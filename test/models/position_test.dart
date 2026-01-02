import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('Position', () {
    test('ボード上にあるかを判定できる', () {
      final inside = Position(row: 2, col: 3);
      final corner = Position(row: GameConstants.boardSize - 1, col: 0);
      final outside = Position(row: -1, col: GameConstants.boardSize);

      expect(inside.isOnBoard, isTrue);
      expect(corner.isOnBoard, isTrue);
      expect(outside.isOnBoard, isFalse);
      expect(inside.key, '2,3');
      expect(inside.offset(-2, 1), equals(Position(row: 0, col: 4)));
    });

    test('JSON 変換に対応している', () {
      final position = Position(row: 4, col: 1);
      final restored = Position.fromJson(position.toJson());
      expect(restored, equals(position));
    });
  });
}
