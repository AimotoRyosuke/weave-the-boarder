import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/core/exceptions/invalid_action_exception.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/services/game/area_detector.dart';
import 'package:weave_the_border/services/game/border_helper.dart';

/// ゲームのルールとバリデーションを管理するサービス。
/// 移動、壁の配置、エナジーの使用などのアクションが有効かどうかを判定します。
class GameRuleService {
  const GameRuleService([this.areaDetector = const AreaDetector()]);

  final AreaDetector areaDetector;

  /// アクションの種類に応じた配置の妥当性を一括で判定します（UI用）。
  bool isValidPlacement({
    required GameState state,
    required ActionType actionType,
    required List<BorderEdge> pendingEdges,
    List<BorderEdge>? selectedEdges,
  }) {
    if (pendingEdges.isEmpty) return true;

    return switch (actionType) {
      ActionType.placeShortWall =>
        pendingEdges.length == 1 &&
            canPlaceWall(
              state,
              pendingEdges.first.anchor,
              pendingEdges.first.orientation,
            ),
      ActionType.placeLongWall =>
        pendingEdges.length == 2 && canPlaceLongWall(state, pendingEdges),
      ActionType.relocateWall =>
        selectedEdges != null &&
            pendingEdges.length == selectedEdges.length &&
            canRelocateWalls(state, selectedEdges, pendingEdges),
      _ => true,
    };
  }

  /// 指定したマスへ移動できるかどうかを判定します。
  bool canMove(GameState state, Position target) {
    if (state.actionsRemaining <= 0) return false;
    if (!target.isOnBoard) return false;

    // 相手または自分のコマがあるマスには移動できない
    for (final p in state.players) {
      if (p.piecePosition == target) return false;
    }

    final source = state.activePlayer.piecePosition;
    final orientation = BorderHelper.orientationBetween(source, target);
    if (orientation == null) return false;

    // 壁がある場合は移動できない
    return !BorderHelper.hasBorderBetween(source, target, state.board.borders);
  }

  /// 1マス壁を配置できるかどうかを判定します。
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

    // 既に壁がある場合は配置できない
    if (BorderHelper.findEdgeBetween(anchor, neighbor, state.board.borders) !=
        null) {
      return false;
    }

    // 分断チェック：壁を置いた結果、いずれかのマスが孤立しないか確認
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

  /// 2マス壁（長壁）を配置できるかどうかを判定します。
  bool canPlaceLongWall(GameState state, List<BorderEdge> edges) {
    if (state.actionsRemaining <= 0) return false;
    if (state.activePlayer.longWalls <= 0) return false;
    if (edges.length != 2) return false;

    // 直線上に並んでいるかチェック
    if (edges[0].orientation != edges[1].orientation) return false;

    // 2マス壁同士の交差（＋の形）チェック
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

    // 分断チェック
    final tempBorders = [...state.board.borders, ...edges];
    return areaDetector.allCellsConnected(state.board.cells, tempBorders);
  }

  /// 2マス壁が既存の他の2マス壁と十字に交差（＋の形）するかどうかを判定します。
  bool _isCrossing(GameState state, List<BorderEdge> edges) {
    if (edges.length != 2) return false;
    final e1 = edges[0];
    final e2 = edges[1];

    final bool isHorizontal =
        e1.orientation == BorderOrientation.top ||
        e1.orientation == BorderOrientation.bottom;

    // 既存のすべての壁に対して、垂直方向の2マス壁との交差をチェック
    for (final border in state.board.borders) {
      if (border.groupId == null) continue;

      // 同じグループのもう一つのエッジを探す
      final sibling = state.board.borders.firstWhere(
        (b) => b.groupId == border.groupId && b != border,
        orElse: () => border,
      );
      if (sibling == border) continue; // 1マス壁の場合はスキップ

      final bool otherIsHorizontal =
          border.orientation == BorderOrientation.top ||
          border.orientation == BorderOrientation.bottom;

      if (isHorizontal != otherIsHorizontal) {
        // 向きが異なる（一方が横、もう一方が縦）場合、中心点が重なるかチェック
        final center1 = _getWallCenter(e1, e2);
        final center2 = _getWallCenter(border, sibling);

        if (center1 != null && center2 != null && center1 == center2) {
          return true;
        }
      }
    }
    return false;
  }

  /// 2マス壁の中心点（4つのマスが接する角の座標）を返します。
  Position? _getWallCenter(BorderEdge e1, BorderEdge e2) {
    if (e1.orientation != e2.orientation) return null;

    final r1 = e1.anchor.row;
    final c1 = e1.anchor.col;
    final r2 = e2.anchor.row;
    final c2 = e2.anchor.col;

    switch (e1.orientation) {
      case BorderOrientation.top:
        return Position(row: r1, col: (c1 < c2 ? c2 : c1));
      case BorderOrientation.bottom:
        return Position(row: r1 + 1, col: (c1 < c2 ? c2 : c1));
      case BorderOrientation.left:
        return Position(row: (r1 < r2 ? r2 : r1), col: c1);
      case BorderOrientation.right:
        return Position(row: (r1 < r2 ? r2 : r1), col: c1 + 1);
    }
  }

  /// プレイヤーがエナジーを所持しているか確認します。
  bool hasEnergy(GameState state) => state.activePlayer.energy > 0;

  /// 特殊アクション「2マス移動」ができるかどうかを判定します。
  bool canUseDoubleMove(GameState state, Position target) {
    if (state.actionsRemaining <= 0 || !hasEnergy(state)) return false;
    final start = state.activePlayer.piecePosition;

    // 相手または自分のコマがあるマスには移動できない
    for (final p in state.players) {
      if (p.piecePosition == target) return false;
    }

    // 1マスで届く場所は「2マス移動」の対象外
    if (_isReachable(state, start, target, 1)) return false;

    // ちょうど2マスで届くか確認
    return _isReachable(state, start, target, 2);
  }

  /// 指定されたステップ数以内で目的地に到達可能かチェックします（BFS的な探索）。
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

      // 移動の途中で他のコマがあるマスを通過することはできない
      bool occupied = false;
      for (final p in state.players) {
        if (p.piecePosition == neighbor && neighbor != end) occupied = true;
      }
      if (occupied) continue;

      if (_isReachable(state, neighbor, end, maxSteps - 1)) return true;
    }
    return false;
  }

  /// コマを移動させ、その結果のゲーム状態を返します。
  GameState movePiece(GameState state, Position destination) {
    _ensure(canMove(state, destination), '移動できないマスです。');

    var newState = _applyMove(state, destination);
    newState = _collectEnergyIfAny(newState, destination);

    return newState.copyWith(actionsRemaining: state.actionsRemaining - 1);
  }

  /// 1マス壁を配置し、その結果のゲーム状態を返します。
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

  /// 2マス壁を配置し、その結果のゲーム状態を返します。
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

  /// 壁の再配置アクションができるかどうかを判定します。
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

    // 元と同じ場所に置くことはできない（エナジー消費の無駄遣い防止）
    bool isSameLocation = true;
    for (final oldEdge in oldEdges) {
      final neighbor = BorderHelper.getNeighbor(
        oldEdge.anchor,
        oldEdge.orientation,
      );
      if (BorderHelper.findEdgeBetween(oldEdge.anchor, neighbor, newEdges) ==
          null) {
        isSameLocation = false;
        break;
      }
    }
    if (isSameLocation) return false;

    // 交差チェック
    if (newEdges.length == 2 && _isCrossing(state, newEdges)) return false;

    // 分断チェック：一時的に壁を取り除いた状態で判定を行う
    final oldEdgesSet = oldEdges.toSet();
    final removedBorders = state.board.borders
        .where((b) => !oldEdgesSet.contains(b))
        .toList();

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

  /// 壁を再配置し、その結果のゲーム状態を返します。
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

  /// 2マス移動を実行し、その結果のゲーム状態を返します。
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

  /// パスを実行し、残りのアクション数を減らします。
  GameState passAction(GameState state) {
    return state.copyWith(actionsRemaining: state.actionsRemaining - 1);
  }

  /// 内部用：実際にコマの座標を更新し、マスを自分の色に塗り替えます。
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

  /// 内部用：移動先のマスにエナジーがある場合、それを獲得します。
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

  /// 手番を終了し、次のプレイヤーへ交代します。
  GameState endTurn(GameState state) {
    return state.copyWith(
      currentTurn: state.currentTurn.opponent,
      turnCount: state.turnCount + 1,
      actionsRemaining: GameConstants.actionsPerTurn,
    );
  }

  /// 内部用：プレイヤーリスト内の特定のプレイヤー情報を更新します。
  List<Player> _replacePlayer(List<Player> players, Player updated) => players
      .map((player) => player.color == updated.color ? updated : player)
      .toList();

  /// 内部用：ボード上のエナジースタックの状態を更新します。
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

  /// アクション実行前の最終的な整合性チェック。失敗した場合は例外をスローします。
  void _ensure(bool condition, String message) {
    if (!condition) throw InvalidActionException(message);
  }
}
