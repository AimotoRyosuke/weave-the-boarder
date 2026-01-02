import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('EnergyTokenStack', () {
    test('トークンの有無と隣接判定', () {
      final center = Position(row: 2, col: 2);
      final stack = EnergyTokenStack(position: center, count: 2);
      final empty = EnergyTokenStack(position: center);

      expect(stack.hasTokens, isTrue);
      expect(stack.tokensAdjacent(center), 2);
      expect(stack.tokensAdjacent(Position(row: 0, col: 0)), 0);
      expect(empty.hasTokens, isFalse);
    });

    test('JSON 変換に対応している', () {
      final stack = EnergyTokenStack(
        position: Position(row: 3, col: 1),
        count: 1,
      );
      expect(EnergyTokenStack.fromJson(stack.toJson()), equals(stack));
    });
  });
}
