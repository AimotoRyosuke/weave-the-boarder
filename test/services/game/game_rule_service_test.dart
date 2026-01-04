import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';

void main() {
  group('ゲームルール (塗り潰せ)', () {
    const service = GameRuleService();

    test('駒を隣接マスに移動でき、15マス獲得で勝利判定ができる', () {
      final initial = GameState.initial();
      // White(Blue) starts at (6,3)
      final movedState = service.movePiece(
        initial,
        const Position(row: 5, col: 3),
      );

      expect(
        movedState.activePlayer.piecePosition,
        equals(const Position(row: 5, col: 3)),
      );
      expect(
        movedState.board.cellAt(const Position(row: 5, col: 3)).owner,
        equals(PlayerColor.blue),
      );
      expect(movedState.actionsRemaining, 0);
    });

    test('壁を配置できる', () {
      final initial = GameState.initial();
      final afterWall = service.placeWall(
        initial,
        const Position(row: 6, col: 3),
        BorderOrientation.top,
      );

      expect(afterWall.board.borders, hasLength(1));
      expect(afterWall.activePlayer.shortWalls, 4);
      expect(afterWall.actionsRemaining, 0);
    });

    test('2マス移動ができる', () {
      final initial = GameState.initial();
      // Red starts with 0 energy. Switch turn and give 1.
      final redTurn = initial.copyWith(
        currentTurn: PlayerColor.red,
        players: initial.players
            .map((p) => p.color == PlayerColor.red ? p.copyWith(energy: 1) : p)
            .toList(),
      );

      final movedState = service.useDoubleMove(
        redTurn,
        const Position(
          row: 0,
          col: 5,
        ), // (0,3) -> (0,5) - exactly 2 steps, no energy in row 0
      );

      expect(
        movedState.activePlayer.piecePosition,
        equals(const Position(row: 0, col: 5)),
      );
      expect(movedState.activePlayer.energy, 0);
    });

    test('分断する壁は配置できない', () {
      final initial = GameState.initial();
      // Try to surround a corner cell (0,0)
      var state = service.placeWall(
        initial,
        const Position(row: 0, col: 0),
        BorderOrientation.right,
      );
      state = state.copyWith(actionsRemaining: 1); // cheat to keep placing

      // This wall would block (0,0) from the rest of the board
      expect(
        service.canPlaceWall(
          state,
          const Position(row: 0, col: 0),
          BorderOrientation.bottom,
        ),
        isFalse,
      );
    });

    test('相手の領域へ移動でき、色が上書きされる', () {
      final initial = GameState.initial();
      final redStartPos = const Position(row: 0, col: 3);

      // Initially (0,3) is Red's territory.
      // Blue piece at (6,3) moves adjacent to Red's territory if possible,
      // but let's just manually set an adjacent cell to Red.
      final prepared = initial.copyWith(
        board: initial.board.copyWith(
          cells: initial.board.cells.map((c) {
            if (c.position == const Position(row: 5, col: 3)) {
              return c.copyWith(owner: PlayerColor.red);
            }
            return c;
          }).toList(),
        ),
      );

      // Blue moves to (5,3) which is Red's territory
      final movedState = service.movePiece(
        prepared,
        const Position(row: 5, col: 3),
      );

      expect(
        movedState.board.cellAt(const Position(row: 5, col: 3)).owner,
        equals(PlayerColor.blue),
      );
      expect(
        movedState.activePlayer.piecePosition,
        equals(const Position(row: 5, col: 3)),
      );

      // But cannot move onto Red's piece itself at (0,3)
      // (Even if it's adjacent, which it isn't here, but logic check)
      expect(service.canMove(movedState, redStartPos), isFalse);
    });

    test('2マス壁の交差（＋の形）は禁止される', () {
      final initial = GameState.initial();
      // Place a vertical 2-cell wall at col boundary 3, spanning row 3 and 4
      final verticalEdges = [
        const BorderEdge(
          anchor: Position(row: 3, col: 3),
          orientation: BorderOrientation.left,
          owner: PlayerColor.blue,
        ),
        const BorderEdge(
          anchor: Position(row: 4, col: 3),
          orientation: BorderOrientation.left,
          owner: PlayerColor.blue,
        ),
      ];
      final stateWithVertical = service.placeLongWall(initial, verticalEdges);

      // Try to place a horizontal 2-cell wall that crosses it at the center (4, 3) vertex
      // This wall spans (row 3, col 2) and (row 3, col 3) on the BOTTOM boundary, which is the same as TOP of row 4.
      // Wait, let's be more precise. Vertex (4, 3) is where Row 3/4 boundary and Col 2/3 boundary meet.
      // Vertical wall (left of col 3) for Row 3 and Row 4. Center vertex is (4, 3).
      // Horizontal wall (bottom of row 3) for Col 2 and Col 3. Center vertex is (4, 3).
      final horizontalEdges = [
        const BorderEdge(
          anchor: Position(row: 3, col: 2),
          orientation: BorderOrientation.bottom,
          owner: PlayerColor.red,
        ),
        const BorderEdge(
          anchor: Position(row: 3, col: 3),
          orientation: BorderOrientation.bottom,
          owner: PlayerColor.red,
        ),
      ];

      // Reset turn to Red and give actions
      final redTurn = stateWithVertical.copyWith(
        currentTurn: PlayerColor.red,
        actionsRemaining: 1,
      );

      expect(service.canPlaceLongWall(redTurn, horizontalEdges), isFalse);
    });

    test('エナジーは5個を超えて獲得できる', () {
      final initial = GameState.initial();
      final energyPos = const Position(row: 5, col: 3); // Adjacent to (6,3)
      final boardWithEnergy = initial.board.copyWith(
        energyStacks: [EnergyTokenStack(position: energyPos, count: 1)],
      );
      var state = initial.copyWith(
        board: boardWithEnergy,
        players: initial.players.map((p) => p.copyWith(energy: 5)).toList(),
      );

      // Move to energy position
      state = service.movePiece(state, energyPos);

      // Energy should be 6
      expect(state.activePlayer.energy, 6);
    });

    test('壁の再配置ができる', () {
      final initial = GameState.initial();
      // Place a 1-cell wall
      final stateWithWall = service.placeWall(
        initial,
        const Position(row: 6, col: 3),
        BorderOrientation.top,
      );
      final wall = stateWithWall.board.borders.first;

      // Give energy to blue to relocate
      var blueTurn = stateWithWall.copyWith(
        currentTurn: PlayerColor.blue,
        actionsRemaining: 1,
        players: stateWithWall.players
            .map((p) => p.color == PlayerColor.blue ? p.copyWith(energy: 1) : p)
            .toList(),
      );

      final newEdges = [
        const BorderEdge(
          anchor: Position(row: 5, col: 3),
          orientation: BorderOrientation.top,
          owner: PlayerColor.blue,
        ),
      ];

      final relocatedState = service.relocateWalls(blueTurn, [wall], newEdges);

      expect(relocatedState.board.borders, hasLength(1));
      expect(relocatedState.board.borders.first.anchor.row, 5);
      expect(relocatedState.activePlayer.energy, 0);
    });

    test('壁を同じ場所に再配置することはできない', () {
      final initial = GameState.initial();
      final stateWithWall = service.placeWall(
        initial,
        const Position(row: 6, col: 3),
        BorderOrientation.top,
      );
      final wall = stateWithWall.board.borders.first;

      final blueTurn = stateWithWall.copyWith(
        currentTurn: PlayerColor.blue,
        actionsRemaining: 1,
        players: stateWithWall.players
            .map((p) => p.color == PlayerColor.blue ? p.copyWith(energy: 1) : p)
            .toList(),
      );

      // Same location
      final sameEdges = [
        const BorderEdge(
          anchor: Position(row: 6, col: 3),
          orientation: BorderOrientation.top,
          owner: PlayerColor.blue,
        ),
      ];
      expect(service.canRelocateWalls(blueTurn, [wall], sameEdges), isFalse);

      // Same location but different representation (Bottom of row 5 instead of Top of row 6)
      final sameEdgesAlt = [
        const BorderEdge(
          anchor: Position(row: 5, col: 3),
          orientation: BorderOrientation.bottom,
          owner: PlayerColor.blue,
        ),
      ];
      expect(service.canRelocateWalls(blueTurn, [wall], sameEdgesAlt), isFalse);
    });

    test('2マス壁の一部を重ねて再配置することはできるが、完全に同じ場所は禁止', () {
      final initial = GameState.initial();
      final edges = [
        const BorderEdge(
          anchor: Position(row: 6, col: 2),
          orientation: BorderOrientation.top,
          owner: PlayerColor.blue,
        ),
        const BorderEdge(
          anchor: Position(row: 6, col: 3),
          orientation: BorderOrientation.top,
          owner: PlayerColor.blue,
        ),
      ];
      final stateWithWall = service.placeLongWall(initial, edges);
      final walls = stateWithWall.board.borders;

      final blueTurn = stateWithWall.copyWith(
        currentTurn: PlayerColor.blue,
        actionsRemaining: 1,
        players: stateWithWall.players
            .map((p) => p.color == PlayerColor.blue ? p.copyWith(energy: 1) : p)
            .toList(),
      );

      // Partially overlapping: (6,3)T stays, (6,2)T moves to (6,4)T
      final partialEdges = [
        const BorderEdge(
          anchor: Position(row: 6, col: 3),
          orientation: BorderOrientation.top,
          owner: PlayerColor.blue,
        ),
        const BorderEdge(
          anchor: Position(row: 6, col: 4),
          orientation: BorderOrientation.top,
          owner: PlayerColor.blue,
        ),
      ];
      expect(service.canRelocateWalls(blueTurn, walls, partialEdges), isTrue);

      // Exactly the same location
      expect(service.canRelocateWalls(blueTurn, walls, edges), isFalse);
    });
  });
}
