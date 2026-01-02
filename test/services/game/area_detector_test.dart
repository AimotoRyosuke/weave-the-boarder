import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/area_detector.dart';
import 'package:weave_the_border/models/game/game_state.dart';

void main() {
  group('エリア検出', () {
    test('同じ色でつながった領域をまとめる', () {
      final state = GameState.initial();
      final detector = const AreaDetector();

      final whiteAreas = detector.detectConnectedAreas(
        state.board,
        PlayerColor.white,
      );
      final blackAreas = detector.detectConnectedAreas(
        state.board,
        PlayerColor.black,
      );

      expect(whiteAreas, hasLength(1));
      expect(blackAreas, hasLength(1));
      expect(
        whiteAreas.first,
        contains(
          state.players
              .firstWhere((p) => p.color == PlayerColor.white)
              .piecePosition,
        ),
      );
    });

    test('囲まれたエリアを完全に囲めていることを判定できる', () {
      final initial = GameState.initial();
      final fencedBoard = initial.board.copyWith(
        borders: [
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
        ],
      );
      final detector = const AreaDetector();
      final area = {const Position(row: 0, col: 0)};

      final isEnclosed = detector.isFullyEnclosed(fencedBoard, area);
      final perimeter = detector.perimeterBorders(fencedBoard, area);

      expect(isEnclosed, isTrue);
      expect(
        perimeter.every((edge) => edge.owner == PlayerColor.white),
        isTrue,
      );
      expect(perimeter.length, 2);
    });
  });
}
