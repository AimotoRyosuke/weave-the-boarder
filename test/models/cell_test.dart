import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('Cell', () {
    test('所有者の有無によって制御されているか判定', () {
      final controlled = Cell(
        position: Position(row: 1, col: 1),
        owner: PlayerColor.red,
      );
      final neutral = Cell(position: Position(row: 1, col: 2));

      expect(controlled.isControlled, isTrue);
      expect(neutral.isControlled, isFalse);
      expect(Cell.fromJson(controlled.toJson()), equals(controlled));
    });
  });
}
