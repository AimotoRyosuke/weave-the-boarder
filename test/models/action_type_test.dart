import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/action_type.dart';

void main() {
  group('ActionType', () {
    test('説明が固定値と一致', () {
      final expectedDescriptions = {
        ActionType.move: '駒を移動',
        ActionType.placeBorder: '境界設置',
        ActionType.collectEnergy: 'エネルギー収集',
        ActionType.specialMove: '追加移動',
        ActionType.specialBreakBorder: '境界破壊',
        ActionType.specialFortify: '要塞化',
        ActionType.pass: 'パス',
      };

      for (final entry in expectedDescriptions.entries) {
        expect(entry.key.description, equals(entry.value));
      }
    });
  });
}
