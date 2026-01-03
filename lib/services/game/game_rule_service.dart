import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/core/exceptions/invalid_action_exception.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/area_detector.dart';
import 'package:weave_the_border/services/game/border_helper.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';

class GameRuleService {
  const GameRuleService([this.areaDetector = const AreaDetector()]);

  static const specialMoveCost = 1;
  static const specialBreakCost = 2;
  static const specialFortifyCost = 3;

  final AreaDetector areaDetector;

  ScoreCalculator get scoreCalculator => ScoreCalculator(areaDetector);

  Map<PlayerColor, ScoreDetail> score(GameState state) =>
      scoreCalculator.evaluate(state);

  ScoreDetail detail(GameState state, PlayerColor color) =>
      scoreCalculator.evaluate(state)[color]!;

  bool canMove(GameState state, Position target) {
    if (!target.isOnBoard) {
      return false;
    }
    if (target == state.activePlayer.piecePosition) {
      return false;
    }
    final orientation = BorderHelper.orientationBetween(
      state.activePlayer.piecePosition,
      target,
    );
    if (orientation == null) {
      return false;
    }
    final targetCell = state.board.cellAt(target);
    if (targetCell.owner != null) {
      return false;
    }
    if (BorderHelper.hasBorderBetween(
      state.activePlayer.piecePosition,
      target,
      state.board.borders,
    )) {
      return false;
    }
    return true;
  }

  bool canPlaceBorder(
    GameState state,
    Position anchor,
    BorderOrientation orientation,
  ) {
    if (!anchor.isOnBoard) {
      return false;
    }

    if (BorderHelper.findByAnchor(anchor, orientation, state.board.borders) !=
        null) {
      return false;
    }

    final boundaryNeighbor = BorderHelper.getNeighbor(anchor, orientation);
    final board = state.board;
    final owner = state.activePlayer.color;

    final isAnchorOwned = board.cellAt(anchor).owner == owner;
    final isNeighborOwned = boundaryNeighbor.isOnBoard
        ? board.cellAt(boundaryNeighbor).owner == owner
        : false;

    if (!isAnchorOwned && !isNeighborOwned) {
      return false;
    }

    return state.activePlayer.remainingBorders > 0;
  }

  bool canCollectEnergy(GameState state, Position energyPosition) {
    final stack = state.board.stackAt(energyPosition);
    if (!stack.hasTokens) {
      return false;
    }
    if (state.activePlayer.energy >= GameConstants.maxEnergyTokens) {
      return false;
    }
    if (_isCenter(energyPosition)) {
      return true;
    }
    return _adjacentToControlledCell(
      state.board,
      energyPosition,
      state.activePlayer.color,
    );
  }

  bool canUseSpecialMove(GameState state, Position target) {
    return hasEnoughEnergy(state, specialMoveCost) && canMove(state, target);
  }

  bool canBreakBorder(GameState state, BorderEdge edge) {
    if (!hasEnoughEnergy(state, specialBreakCost)) {
      return false;
    }
    final existing = BorderHelper.findEdgeBetween(
      edge.anchor,
      BorderHelper.getNeighbor(edge.anchor, edge.orientation),
      state.board.borders,
    );
    if (existing == null) {
      return false;
    }
    if (existing.owner == state.activePlayer.color) {
      return false;
    }
    if (existing.isFortified) {
      return false;
    }
    return true;
  }

  bool canFortifyArea(GameState state, Set<Position> area) {
    if (!hasEnoughEnergy(state, specialFortifyCost)) {
      return false;
    }
    if (area.isEmpty) {
      return false;
    }
    for (final position in area) {
      if (!position.isOnBoard) {
        return false;
      }
      if (state.board.cellAt(position).owner != state.activePlayer.color) {
        return false;
      }
    }
    if (!areaDetector.isFullyEnclosed(state.board, area)) {
      return false;
    }
    final perimeter = areaDetector.perimeterBorders(state.board, area);
    return perimeter.any((edge) => edge.owner == state.activePlayer.color);
  }

  bool hasEnoughEnergy(GameState state, int cost) =>
      state.activePlayer.energy >= cost;

  GameState movePiece(GameState state, Position destination) {
    _ensure(canMove(state, destination), '移動できないマスです。');
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

  GameState placeBorder(
    GameState state,
    Position anchor,
    BorderOrientation orientation,
  ) {
    _ensure(canPlaceBorder(state, anchor, orientation), '境界を配置できません。');

    final newEdge = BorderEdge(
      anchor: anchor,
      orientation: orientation,
      owner: state.activePlayer.color,
    );

    final updatedBorders = [...state.board.borders, newEdge];
    final updatedPlayer = state.activePlayer.copyWith(
      remainingBorders: state.activePlayer.remainingBorders - 1,
    );

    return state.copyWith(
      board: state.board.copyWith(borders: updatedBorders),
      players: _replacePlayer(state.players, updatedPlayer),
    );
  }

  GameState collectEnergy(GameState state, Position energyPosition) {
    _ensure(canCollectEnergy(state, energyPosition), 'エネルギーを取得できません。');

    final stack = state.board.stackAt(energyPosition);
    final updatedStack = stack.copyWith(count: stack.count - 1);
    final newStacks = _replaceEnergyStack(
      state.board.energyStacks,
      updatedStack,
    );
    final updatedBoard = state.board.copyWith(energyStacks: newStacks);
    final newEnergy = (state.activePlayer.energy + 1).clamp(
      0,
      GameConstants.maxEnergyTokens,
    );
    final updatedPlayer = state.activePlayer.copyWith(energy: newEnergy);

    return state.copyWith(
      board: updatedBoard,
      players: _replacePlayer(state.players, updatedPlayer),
    );
  }

  GameState specialMove(GameState state, Position destination) {
    _ensure(canUseSpecialMove(state, destination), '特殊移動を実行できません。');

    final movedState = movePiece(state, destination);
    final afterCost = _deductEnergy(movedState, specialMoveCost);
    return afterCost;
  }

  GameState breakBorder(GameState state, BorderEdge edge) {
    _ensure(canBreakBorder(state, edge), '境界破壊を実行できません。');

    final targetNeighbor = BorderHelper.getNeighbor(
      edge.anchor,
      edge.orientation,
    );
    final existing = BorderHelper.findEdgeBetween(
      edge.anchor,
      targetNeighbor,
      state.board.borders,
    );
    _ensure(existing != null, '対象の境界が見つかりません。');

    final updatedBorders = state.board.borders
        .where((border) => border != existing)
        .toList();

    final afterCost = _deductEnergy(
      state.copyWith(board: state.board.copyWith(borders: updatedBorders)),
      specialBreakCost,
    );

    return afterCost;
  }

  GameState fortifyArea(GameState state, Set<Position> area) {
    _ensure(canFortifyArea(state, area), '要塞化できるエリアではありません。');

    final perimeter = areaDetector
        .perimeterBorders(state.board, area)
        .where((edge) => edge.owner == state.activePlayer.color)
        .toSet();

    final updatedBorders = state.board.borders.map((edge) {
      if (perimeter.contains(edge)) {
        return edge.copyWith(isFortified: true);
      }
      return edge;
    }).toList();

    final afterCost = _deductEnergy(
      state.copyWith(board: state.board.copyWith(borders: updatedBorders)),
      specialFortifyCost,
    );

    return afterCost;
  }

  GameState endTurn(GameState state) {
    final nextTurn = state.currentTurn.opponent;
    final refreshedBoard = _refillCenterEnergy(state.board);

    return state.copyWith(
      board: refreshedBoard,
      currentTurn: nextTurn,
      turnCount: state.turnCount + 1,
    );
  }

  GameState _deductEnergy(GameState state, int cost) {
    final player = state.activePlayer;
    final updatedPlayer = player.copyWith(energy: player.energy - cost);
    return state.copyWith(
      players: _replacePlayer(state.players, updatedPlayer),
    );
  }

  List<Player> _replacePlayer(List<Player> players, Player updated) =>
      players.map((player) {
        if (player.color == updated.color) {
          return updated;
        }
        return player;
      }).toList();

  List<EnergyTokenStack> _replaceEnergyStack(
    List<EnergyTokenStack> current,
    EnergyTokenStack updated,
  ) {
    final filtered = current.where(
      (stack) => stack.position != updated.position,
    );
    final combined = [...filtered];
    if (updated.count > 0) {
      combined.add(updated);
    }
    return combined;
  }

  Board _refillCenterEnergy(Board board) {
    final centerIndex = GameConstants.boardSize ~/ 2;
    final centerPosition = Position(row: centerIndex, col: centerIndex);
    final currentCount = board.stackAt(centerPosition).count;

    if (currentCount < GameConstants.initialCenterEnergy) {
      final updatedStack = EnergyTokenStack(
        position: centerPosition,
        count: GameConstants.initialCenterEnergy,
      );
      final stacks = _replaceEnergyStack(board.energyStacks, updatedStack);
      return board.copyWith(energyStacks: stacks);
    }
    return board;
  }

  bool _adjacentToControlledCell(
    Board board,
    Position energyPosition,
    PlayerColor color,
  ) {
    for (final neighbor in BorderHelper.orthogonalNeighbors(energyPosition)) {
      if (!neighbor.isOnBoard) {
        continue;
      }
      if (board.cellAt(neighbor).owner == color) {
        return true;
      }
    }
    return false;
  }

  bool _isCenter(Position position) {
    final center = GameConstants.boardSize ~/ 2;
    return position.row == center && position.col == center;
  }

  void _ensure(bool condition, String message) {
    if (!condition) {
      throw InvalidActionException(message);
    }
  }
}
