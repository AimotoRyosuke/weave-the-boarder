import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('BorderEdge', () {
    test('方向ベクトルを返す', () {
      expect(BorderOrientation.top.dRow, -1);
      expect(BorderOrientation.top.dCol, 0);
      expect(BorderOrientation.bottom.dRow, 1);
      expect(BorderOrientation.bottom.dCol, 0);
      expect(BorderOrientation.left.dRow, 0);
      expect(BorderOrientation.left.dCol, -1);
      expect(BorderOrientation.right.dRow, 0);
      expect(BorderOrientation.right.dCol, 1);
    });

    test('JSON 変換に対応している', () {
      final edge = BorderEdge(
        anchor: Position(row: 2, col: 2),
        orientation: BorderOrientation.right,
        owner: PlayerColor.white,
        isFortified: true,
      );
      expect(BorderEdge.fromJson(edge.toJson()), equals(edge));
    });
  });
}
