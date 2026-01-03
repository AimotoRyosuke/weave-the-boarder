import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/core/exceptions/invalid_action_exception.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/area_detector.dart';
import 'package:weave_the_border/services/game/border_helper.dart';

class GameRuleService {
  const GameRuleService([this.areaDetector = const AreaDetector()]);

  final AreaDetector areaDetector;

  bool canMove(GameState state, Position target) {
    if (state.actionsRemaining <= 0) return false;
    if (!target.isOnBoard) return false;

    // Cannot move to a cell occupied by ANY player's piece
    for (final p in state.players) {
      if (p.piecePosition == target) return false;
    }

    final source = state.activePlayer.piecePosition;
    final orientation = BorderHelper.orientationBetween(source, target);
    if (orientation == null) return false;

    // Check for wall
    return !BorderHelper.hasBorderBetween(source, target, state.board.borders);
  }

  bool canPlaceWall(
    GameState state,
    Position anchor,
    BorderOrientation orientation,
  ) {
    if (state.actionsRemaining <= 0) return false;
    if (state.activePlayer.shortWalls <= 0) return false;
    if (!anchor.isOnBoard) return false;

    final neighbor = BorderHelper.getNeighbor(anchor, orientation);
    if (!neighbor.isOnBoard) return false;

    // Already has a wall
    if (BorderHelper.findEdgeBetween(anchor, neighbor, state.board.borders) !=
        null) {
      return false;
    }

    // Connectivity check
    final tempBorders = [
      ...state.board.borders,
      BorderEdge(
        anchor: anchor,
        orientation: orientation,
        owner: state.activePlayer.color,
      ),
    ];
    return areaDetector.allCellsConnected(state.board.cells, tempBorders);
  }

  bool canPlaceLongWall(GameState state, List<BorderEdge> edges) {
    if (state.actionsRemaining <= 0) return false;
    if (state.activePlayer.longWalls <= 0) return false;
    if (edges.length != 2) return false;

    // Check if straight line
    if (edges[0].orientation != edges[1].orientation) return false;

    // Crossing check
    if (_isCrossing(state, edges)) return false;

    for (final edge in edges) {
      if (!edge.anchor.isOnBoard) return false;
      final neighbor = BorderHelper.getNeighbor(edge.anchor, edge.orientation);
      if (!neighbor.isOnBoard) return false;
      if (BorderHelper.findEdgeBetween(
            edge.anchor,
            neighbor,
            state.board.borders,
          ) !=
          null) {
        return false;
      }
    }

    // Connectivity check
    final tempBorders = [...state.board.borders, ...edges];
    return areaDetector.allCellsConnected(state.board.cells, tempBorders);
  }

  bool _isCrossing(GameState state, List<BorderEdge> edges) {
    if (edges.length != 2) return false;
    final e1 = edges[0];
    final e2 = edges[1];

    // Identify the "center" of the proposed wall
    // For horizontal (top/bottom), center is between e1.col and e2.col
    // For vertical (left/right), center is between e1.row and e2.row

    final bool isHorizontal =
        e1.orientation == BorderOrientation.top ||
        e1.orientation == BorderOrientation.bottom;

    // We search for a wall of the opposite orientation that shares the same intersection point
    for (final border in state.board.borders) {
      if (border.groupId == null) continue;

      // Find another edge in the same group
      final sibling = state.board.borders.firstWhere(
        (b) => b.groupId == border.groupId && b != border,
        orElse: () => border,
      );
      if (sibling == border) continue; // Not a 2-cell wall

      final bool otherIsHorizontal =
          border.orientation == BorderOrientation.top ||
          border.orientation == BorderOrientation.bottom;

      if (isHorizontal != otherIsHorizontal) {
        // Potential intersection.
        // Horizontal wall at Row R boundary, Col C and C+1. Center Vertex (R, C+1)
        // Vertical wall at Col C boundary, Row R and R+1. Center Vertex (R+1, C)
        // Correct Logic:
        // A horizontal 2nd wall spanning (r, c) and (r, c+1) on row boundary R
        // has center (R, c+1).
        // A vertical 2nd wall spanning (r, c) and (r+1, c) on col boundary C
        // has center (r+1, C).

        // Let's find the centers.
        final center1 = _getWallCenter(e1, e2);
        final center2 = _getWallCenter(border, sibling);

        if (center1 != null && center2 != null && center1 == center2) {
          return true;
        }
      }
    }
    return false;
  }

  // Returns the vertex coordinate (top-left of a cell) that acts as the center of a 2-cell wall
  Position? _getWallCenter(BorderEdge e1, BorderEdge e2) {
    if (e1.orientation != e2.orientation) return null;

    final r1 = e1.anchor.row;
    final c1 = e1.anchor.col;
    final r2 = e2.anchor.row;
    final c2 = e2.anchor.col;

    switch (e1.orientation) {
      case BorderOrientation.top:
        // Center is at the row boundary above, between the two cols
        return Position(row: r1, col: (c1 < c2 ? c2 : c1));
      case BorderOrientation.bottom:
        // Center is at the row boundary below
        return Position(row: r1 + 1, col: (c1 < c2 ? c2 : c1));
      case BorderOrientation.left:
        // Center is at the col boundary to the left, between the two rows
        return Position(row: (r1 < r2 ? r2 : r1), col: c1);
      case BorderOrientation.right:
        // Center is at the col boundary to the right
        return Position(row: (r1 < r2 ? r2 : r1), col: c1 + 1);
    }
  }

  bool hasEnergy(GameState state) => state.activePlayer.energy > 0;

  bool canUseDoubleMove(GameState state, Position target) {
    if (state.actionsRemaining <= 0 || !hasEnergy(state)) return false;
    final start = state.activePlayer.piecePosition;

    // Cannot move to a cell occupied by ANY player's piece
    for (final p in state.players) {
      if (p.piecePosition == target) return false;
    }

    // Exclude cells reachable in 1 step
    if (_isReachable(state, start, target, 1)) return false;

    // Must be reachable in 2 steps
    return _isReachable(state, start, target, 2);
  }

  bool _isReachable(
    GameState state,
    Position start,
    Position end,
    int maxSteps,
  ) {
    if (start == end) return true;
    if (maxSteps <= 0) return false;

    for (final neighbor in BorderHelper.orthogonalNeighbors(start)) {
      if (!neighbor.isOnBoard) continue;
      if (BorderHelper.hasBorderBetween(start, neighbor, state.board.borders)) {
        continue;
      }

      bool occupied = false;
      for (final p in state.players) {
        if (p.piecePosition == neighbor && neighbor != end) occupied = true;
      }
      if (occupied) continue;

      if (_isReachable(state, neighbor, end, maxSteps - 1)) return true;
    }
    return false;
  }

  GameState movePiece(GameState state, Position destination) {
    _ensure(canMove(state, destination), '移動できないマスです。');

    var newState = _applyMove(state, destination);
    newState = _collectEnergyIfAny(newState, destination);

    return newState.copyWith(actionsRemaining: state.actionsRemaining - 1);
  }

  GameState placeWall(
    GameState state,
    Position anchor,
    BorderOrientation orientation,
  ) {
    _ensure(canPlaceWall(state, anchor, orientation), '壁を配置できません。');

    final newEdge = BorderEdge(
      anchor: anchor,
      orientation: orientation,
      owner: state.activePlayer.color,
      groupId: DateTime.now().toIso8601String(),
    );

    final updatedBorders = [...state.board.borders, newEdge];
    final updatedPlayer = state.activePlayer.copyWith(
      shortWalls: state.activePlayer.shortWalls - 1,
    );

    return state.copyWith(
      board: state.board.copyWith(borders: updatedBorders),
      players: _replacePlayer(state.players, updatedPlayer),
      actionsRemaining: state.actionsRemaining - 1,
    );
  }

  GameState placeLongWall(GameState state, List<BorderEdge> edges) {
    _ensure(canPlaceLongWall(state, edges), '長壁を配置できません。');

    final groupId = DateTime.now().toIso8601String();
    final updatedEdges = edges
        .map(
          (e) => e.copyWith(owner: state.activePlayer.color, groupId: groupId),
        )
        .toList();

    final updatedBorders = [...state.board.borders, ...updatedEdges];
    final updatedPlayer = state.activePlayer.copyWith(
      longWalls: state.activePlayer.longWalls - 1,
    );

    return state.copyWith(
      board: state.board.copyWith(borders: updatedBorders),
      players: _replacePlayer(state.players, updatedPlayer),
      actionsRemaining: state.actionsRemaining - 1,
    );
  }

  bool canRelocateWalls(
    GameState state,
    List<BorderEdge> oldEdges,
    List<BorderEdge> newEdges,
  ) {
    if (state.actionsRemaining <= 0 || !hasEnergy(state)) return false;
    if (oldEdges.isEmpty || oldEdges.length != newEdges.length) return false;

    final owner = state.activePlayer.color;
    for (final e in oldEdges) {
      if (e.owner != owner) return false;
    }

    // Crossing check for the new placement
    if (newEdges.length == 2 && _isCrossing(state, newEdges)) return false;

    // Connectivity check
    final oldEdgesSet = oldEdges.toSet();
    final removedBorders =
        state.board.borders.where((b) => !oldEdgesSet.contains(b)).toList();

    for (final e in newEdges) {
      if (!e.anchor.isOnBoard) return false;
      final neighbor = BorderHelper.getNeighbor(e.anchor, e.orientation);
      if (!neighbor.isOnBoard) return false;
      if (BorderHelper.findEdgeBetween(e.anchor, neighbor, removedBorders) !=
          null) {
        return false;
      }
    }

    final tempBorders = [...removedBorders, ...newEdges];
    return areaDetector.allCellsConnected(state.board.cells, tempBorders);
  }

  GameState relocateWalls(
    GameState state,
    List<BorderEdge> oldEdges,
    List<BorderEdge> newEdges,
  ) {
    _ensure(canRelocateWalls(state, oldEdges, newEdges), '壁を移動できません。');

    final player = state.activePlayer;
    final updatedPlayer = player.copyWith(energy: player.energy - 1);

    final oldEdgesSet = oldEdges.toSet();
    final removedBorders = state.board.borders
        .where((b) => !oldEdgesSet.contains(b))
        .toList();

    final groupId = oldEdges.first.groupId ?? DateTime.now().toIso8601String();
    final updatedNewEdges = newEdges
        .map(
          (e) => e.copyWith(owner: state.activePlayer.color, groupId: groupId),
        )
        .toList();

    return state.copyWith(
      board: state.board.copyWith(
        borders: [...removedBorders, ...updatedNewEdges],
      ),
      players: _replacePlayer(state.players, updatedPlayer),
      actionsRemaining: state.actionsRemaining - 1,
    );
  }

  GameState useDoubleMove(GameState state, Position target) {
    _ensure(canUseDoubleMove(state, target), '2マス移動ができません。');

    final player = state.activePlayer;
    final updatedPlayer = player.copyWith(energy: player.energy - 1);

    var newState = state.copyWith(
      players: _replacePlayer(state.players, updatedPlayer),
    );
    newState = _applyMove(newState, target);
    newState = _collectEnergyIfAny(newState, target);

    return newState.copyWith(actionsRemaining: state.actionsRemaining - 1);
  }

  GameState passAction(GameState state) {
    return state.copyWith(actionsRemaining: state.actionsRemaining - 1);
  }

  GameState _applyMove(GameState state, Position destination) {
    final board = state.board;
    final updatedCells = board.cells.map((cell) {
      if (cell.position == destination) {
        return cell.copyWith(owner: state.activePlayer.color);
      }
      return cell;
    }).toList();

    final updatedPlayer = state.activePlayer.copyWith(
      piecePosition: destination,
    );

    return state.copyWith(
      board: board.copyWith(cells: updatedCells),
      players: _replacePlayer(state.players, updatedPlayer),
    );
  }

  GameState _collectEnergyIfAny(GameState state, Position pos) {
    final stack = state.board.stackAt(pos);
    if (!stack.hasTokens) return state;

    final updatedStack = stack.copyWith(count: stack.count - 1);
    final newStacks = _replaceEnergyStack(
      state.board.energyStacks,
      updatedStack,
    );
    final updatedBoard = state.board.copyWith(energyStacks: newStacks);

    final updatedPlayer = state.activePlayer.copyWith(
      energy: state.activePlayer.energy + 1,
    );

    return state.copyWith(
      board: updatedBoard,
      players: _replacePlayer(state.players, updatedPlayer),
    );
  }

  GameState endTurn(GameState state) {
    return state.copyWith(
      currentTurn: state.currentTurn.opponent,
      turnCount: state.turnCount + 1,
      actionsRemaining: GameConstants.actionsPerTurn,
    );
  }

  List<Player> _replacePlayer(List<Player> players, Player updated) => players
      .map((player) => player.color == updated.color ? updated : player)
      .toList();

  List<EnergyTokenStack> _replaceEnergyStack(
    List<EnergyTokenStack> current,
    EnergyTokenStack updated,
  ) {
    final filtered = current
        .where((stack) => stack.position != updated.position)
        .toList();
    if (updated.count > 0) filtered.add(updated);
    return filtered;
  }

  void _ensure(bool condition, String message) {
    if (!condition) throw InvalidActionException(message);
  }
}
