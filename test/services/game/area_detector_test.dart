import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/area_detector.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';

void main() {
  group('エリア検出', () {
    test('同じ色でつながった領域をまとめる', () {
      final state = GameState.initial();
      const detector = AreaDetector();

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
      const detector = AreaDetector();
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

    test('同じプレイヤーの2つの隣接セル間に境界がある場合、2つの別々のエリアとして検出される', () {
      const detector = AreaDetector();
      final cells = List.generate(
        GameConstants.boardSize * GameConstants.boardSize,
        (index) {
          final position = Position(
            row: index ~/ GameConstants.boardSize,
            col: index % GameConstants.boardSize,
          );
          if (position.row == 0 && position.col == 0) {
            return Cell(position: position, owner: PlayerColor.white);
          }
          if (position.row == 0 && position.col == 1) {
            return Cell(position: position, owner: PlayerColor.white);
          }
          return Cell(position: position);
        },
      );

      final board = Board(
        cells: cells,
        borders: [
          BorderEdge(
            anchor: const Position(row: 0, col: 0),
            orientation: BorderOrientation.right,
            owner: PlayerColor.black,
          ),
        ],
        energyStacks: const [],
      );

      final whiteAreas = detector.detectConnectedAreas(board, PlayerColor.white);

      expect(whiteAreas, hasLength(2));
      expect(whiteAreas, contains(equals({const Position(row: 0, col: 0)})));
      expect(whiteAreas, contains(equals({const Position(row: 0, col: 1)})));
    });

    test('複数のセルからなるエリアの内部に境界がある場合、適切に分割される', () {
      const detector = AreaDetector();
      final cells = List.generate(
        GameConstants.boardSize * GameConstants.boardSize,
        (index) {
          final position = Position(
            row: index ~/ GameConstants.boardSize,
            col: index % GameConstants.boardSize,
          );
          if ((position.row == 0 || position.row == 1) &&
              (position.col == 0 || position.col == 1)) {
            return Cell(position: position, owner: PlayerColor.white);
          }
          return Cell(position: position);
        },
      );

      final board = Board(
        cells: cells,
        borders: [
          BorderEdge(
            anchor: const Position(row: 0, col: 0),
            orientation: BorderOrientation.right,
            owner: PlayerColor.black,
          ),
          BorderEdge(
            anchor: const Position(row: 1, col: 0),
            orientation: BorderOrientation.right,
            owner: PlayerColor.black,
          ),
        ],
        energyStacks: const [],
      );

      final whiteAreas = detector.detectConnectedAreas(board, PlayerColor.white);

      expect(whiteAreas, hasLength(2));
      final area1 = {
        const Position(row: 0, col: 0),
        const Position(row: 1, col: 0)
      };
      final area2 = {
        const Position(row: 0, col: 1),
        const Position(row: 1, col: 1)
      };

      expect(
        whiteAreas.any((area) => area.toString() == area1.toString()),
        isTrue,
      );
      expect(
        whiteAreas.any((area) => area.toString() == area2.toString()),
        isTrue,
      );
    });
  });
}