import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/area_detector.dart';
import 'package:weave_the_border/models/game/game_state.dart';

void main() {
  group('AreaDetector', () {
    const detector = AreaDetector();

    test('初期状態で白と黒のエリアが1つずつ存在する', () {
      final state = GameState.initial();

      final blueAreas = detector.detectConnectedAreas(
        state.board,
        PlayerColor.blue,
      );
      final redAreas = detector.detectConnectedAreas(
        state.board,
        PlayerColor.red,
      );

      expect(blueAreas, hasLength(1));
      expect(redAreas, hasLength(1));
      expect(blueAreas.first, contains(const Position(row: 6, col: 3)));
    });

    test('allCellsConnected が壁による分断を正しく検知する', () {
      final initial = GameState.initial();

      // Try to isolate (0,0)
      final borders = [
        BorderEdge(
          anchor: const Position(row: 0, col: 0),
          orientation: BorderOrientation.right,
          owner: PlayerColor.blue,
        ),
        BorderEdge(
          anchor: const Position(row: 0, col: 0),
          orientation: BorderOrientation.bottom,
          owner: PlayerColor.blue,
        ),
      ];

      expect(detector.allCellsConnected(initial.board.cells, borders), isFalse);

      // Only one wall doesn't isolate
      expect(
        detector.allCellsConnected(initial.board.cells, [borders.first]),
        isTrue,
      );
    });
  });
}
