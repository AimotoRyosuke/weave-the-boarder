import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/providers/game/action_provider.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';
import 'package:weave_the_border/services/game/border_helper.dart';
import 'package:weave_the_border/screens/game/widgets/board_cell_widget.dart';
import 'package:weave_the_border/screens/game/widgets/borders_painter.dart';
import 'package:weave_the_border/screens/game/widgets/energy_token_widget.dart';
import 'package:weave_the_border/screens/game/widgets/player_piece_widget.dart';

class GameBoardWidget extends ConsumerWidget {
  const GameBoardWidget({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const ruleService = GameRuleService();
    final currentAction = ref.watch(actionProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth;
        final cellSize = boardSize / GameConstants.boardSize;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _handlePanStart(details, cellSize, ref),
          onPanUpdate: (details) => _handlePanUpdate(details, cellSize, ref),
          onPanEnd: (details) =>
              _handlePanEnd(details, cellSize, ref, ruleService),
          onTapDown: (details) =>
              _handleTapDown(details, cellSize, ref, ruleService),
          onTapUp: (details) => _handleTapUp(details, cellSize, ref),
          child: Stack(
            children: [
              // 1. グリッドセル (盤面のベース)
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameConstants.boardSize,
                ),
                itemCount: GameConstants.boardSize * GameConstants.boardSize,
                itemBuilder: (context, index) {
                  final position = gameState.board.positionFromIndex(index);
                  final cell = gameState.board.cellAt(position);

                  return BoardCellWidget(cell: cell);
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),

              // 2. 壁 (境界線) の描画レイヤー
              IgnorePointer(
                child: CustomPaint(
                  size: Size(boardSize, boardSize),
                  painter: BordersPainter(
                    gameState: gameState,
                    cellSize: cellSize,
                    ruleService: ruleService,
                    actionType: currentAction.type,
                    selectedEdges: currentAction.selectedEdges,
                    pendingEdges: currentAction.pendingEdges,
                  ),
                ),
              ),

              // 3. プレイヤーのコマ
              ...gameState.players.map((player) {
                return _buildPositioned(
                  position: player.piecePosition,
                  cellSize: cellSize,
                  child: IgnorePointer(
                    child: PlayerPieceWidget(
                      key: ValueKey(player.color),
                      player: player,
                    ),
                  ),
                );
              }),

              // 4. エネルギートークン
              ...gameState.board.energyStacks.map((stack) {
                if (!stack.hasTokens) return const SizedBox.shrink();
                return _buildPositioned(
                  position: stack.position,
                  cellSize: cellSize,
                  child: EnergyTokenWidget(stack: stack),
                );
              }),

              // 5. 操作ヒント (移動可能位置や設置予定位置のハイライト)
              ...List.generate(
                GameConstants.boardSize * GameConstants.boardSize,
                (index) {
                  final pos = gameState.board.positionFromIndex(index);
                  final isMovable = switch (currentAction.type) {
                    ActionType.move => ruleService.canMove(gameState, pos),
                    ActionType.doubleMove => ruleService.canUseDoubleMove(
                      gameState,
                      pos,
                    ),
                    _ => false,
                  };

                  final isPending = currentAction.pendingPosition == pos;

                  if (!isMovable && !isPending) return const SizedBox.shrink();

                  return _buildPositioned(
                    position: pos,
                    cellSize: cellSize,
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          width: cellSize * 0.8,
                          height: cellSize * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                              alpha: isPending ? 0.3 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePanStart(
    DragStartDetails details,
    double cellSize,
    WidgetRef ref,
  ) {
    final pos = details.localPosition;
    final state = ref.read(actionProvider);
    final type = state.type;

    if (type == ActionType.move || type == ActionType.doubleMove) {
      _updateMovementTarget(pos, cellSize, ref);
      return;
    }

    final edge = _getEdgeAt(pos.dx, pos.dy, cellSize);
    if (edge == null) return;

    if (type == ActionType.placeShortWall ||
        type == ActionType.placeLongWall ||
        (type == ActionType.relocateWall && state.selectedEdges.isNotEmpty)) {
      ref.read(actionProvider.notifier).setPendingEdges([edge]);
    }
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    double cellSize,
    WidgetRef ref,
  ) {
    final state = ref.read(actionProvider);
    final type = state.type;
    final pos = details.localPosition;

    if (type == ActionType.move || type == ActionType.doubleMove) {
      _updateMovementTarget(pos, cellSize, ref);
      return;
    }

    if (type != ActionType.placeShortWall &&
        type != ActionType.placeLongWall &&
        type != ActionType.relocateWall) {
      return;
    }

    final pending = state.pendingEdges;
    final currentEdge = _getEdgeAt(pos.dx, pos.dy, cellSize);

    if (currentEdge == null) {
      if (pending.isNotEmpty) {
        ref.read(actionProvider.notifier).setPendingEdges([]);
      }
      return;
    }

    if (pending.isEmpty) {
      ref.read(actionProvider.notifier).setPendingEdges([currentEdge]);
      return;
    }

    final bool isLong =
        type == ActionType.placeLongWall ||
        (type == ActionType.relocateWall && state.selectedEdges.length == 2);

    if (isLong) {
      if (currentEdge == pending.first) return;
      final first = pending.first;
      // 同じ向きの辺のみ連結可能
      if (currentEdge.orientation == first.orientation) {
        final diffRow = (currentEdge.anchor.row - first.anchor.row).abs();
        final diffCol = (currentEdge.anchor.col - first.anchor.col).abs();

        // 上下辺の場合は横に隣接、左右辺の場合は縦に隣接しているかチェック
        bool isAdjacent =
            (first.orientation == BorderOrientation.top ||
                first.orientation == BorderOrientation.bottom)
            ? (diffRow == 0 && diffCol == 1)
            : (diffRow == 1 && diffCol == 0);

        if (isAdjacent) {
          ref.read(actionProvider.notifier).setPendingEdges([
            first,
            currentEdge,
          ]);
        }
      }
    } else {
      // 短い壁（1辺）の場合は、ドラッグ先のエッジに更新するだけ
      if (currentEdge != pending.first) {
        ref.read(actionProvider.notifier).setPendingEdges([currentEdge]);
      }
    }
  }

  void _handlePanEnd(
    DragEndDetails details,
    double cellSize,
    WidgetRef ref,
    GameRuleService ruleService,
  ) {
    _completePendingAction(ref, ruleService);
  }

  void _handleTapDown(
    TapDownDetails details,
    double cellSize,
    WidgetRef ref,
    GameRuleService ruleService,
  ) {
    final pos = details.localPosition;
    final state = ref.read(actionProvider);
    final type = state.type;

    if (type == ActionType.relocateWall) {
      final edge = _getEdgeAt(pos.dx, pos.dy, cellSize);
      if (edge == null) return;

      if (state.selectedEdges.isEmpty) {
        final existing = BorderHelper.findEdgeBetween(
          edge.anchor,
          BorderHelper.getNeighbor(edge.anchor, edge.orientation),
          gameState.board.borders,
        );
        if (existing != null &&
            existing.owner == gameState.activePlayer.color) {
          final group = existing.groupId != null
              ? gameState.board.borders
                    .where((b) => b.groupId == existing.groupId)
                    .toList()
              : [existing];
          ref.read(actionProvider.notifier).selectEdges(group);
        }
      } else {
        ref.read(actionProvider.notifier).setPendingEdges([edge]);
      }
      return;
    }

    if (type == ActionType.move || type == ActionType.doubleMove) {
      _updateMovementTarget(pos, cellSize, ref);
    } else if (type == ActionType.placeShortWall ||
        type == ActionType.placeLongWall) {
      final edge = _getEdgeAt(pos.dx, pos.dy, cellSize);
      if (edge != null) {
        ref.read(actionProvider.notifier).setPendingEdges([edge]);
      }
    }
  }

  void _handleTapUp(TapUpDetails details, double cellSize, WidgetRef ref) {
    const ruleService = GameRuleService();
    _completePendingAction(ref, ruleService);
  }

  void _updateMovementTarget(Offset pos, double cellSize, WidgetRef ref) {
    final col = (pos.dx / cellSize).floor();
    final row = (pos.dy / cellSize).floor();
    final currentPos = Position(row: row, col: col);
    final type = ref.read(actionProvider).type;

    Position? targetPos;
    if (currentPos.isOnBoard) {
      const ruleService = GameRuleService();
      final isValid = (type == ActionType.move)
          ? ruleService.canMove(gameState, currentPos)
          : ruleService.canUseDoubleMove(gameState, currentPos);
      targetPos = isValid ? currentPos : Position.none;
    } else {
      targetPos = Position.none;
    }

    if (ref.read(actionProvider).pendingPosition != targetPos) {
      ref.read(actionProvider.notifier).setPendingPosition(targetPos);
    }
  }

  void _completePendingAction(WidgetRef ref, GameRuleService ruleService) {
    final state = ref.read(actionProvider);

    // 1. 移動アクションの確定処理
    if (state.pendingPosition != null) {
      if (state.pendingPosition != Position.none) {
        if (state.type == ActionType.move) {
          ref
              .read(gameControllerProvider.notifier)
              .movePiece(state.pendingPosition!);
        } else if (state.type == ActionType.doubleMove) {
          ref
              .read(gameControllerProvider.notifier)
              .useDoubleMove(state.pendingPosition!);
        }
      }
      ref.read(actionProvider.notifier).setPendingPosition(null);
      return;
    }

    // 2. 壁設置・移動アクションの確定処理
    final pending = state.pendingEdges;
    if (pending.isNotEmpty) {
      // ルールに基づいて設置可能か検証
      final isValid = ruleService.isValidPlacement(
        state: gameState,
        actionType: state.type,
        pendingEdges: pending,
        selectedEdges: state.selectedEdges,
      );

      if (isValid) {
        if (state.type == ActionType.placeShortWall) {
          final edge = pending.first;
          ref
              .read(gameControllerProvider.notifier)
              .placeWall(edge.anchor, edge.orientation);
          ref.read(actionProvider.notifier).reset();
        } else if (state.type == ActionType.placeLongWall) {
          ref.read(gameControllerProvider.notifier).placeLongWall(pending);
          ref.read(actionProvider.notifier).reset();
        } else if (state.type == ActionType.relocateWall) {
          ref
              .read(gameControllerProvider.notifier)
              .relocateWalls(state.selectedEdges, pending);
          ref.read(actionProvider.notifier).reset();
        }
      }
      // アクション完了後、または無効な場合はリセット
      ref.read(actionProvider.notifier).setPendingEdges([]);
    }
  }

  /// 指定された座標(x, y)にあるエッジ（辺）を特定する
  BorderEdge? _getEdgeAt(double x, double y, double cellSize) {
    // 座標からグリッドの行・列を計算
    final col = (x / cellSize).floor();
    final row = (y / cellSize).floor();
    if (row < 0 ||
        row >= GameConstants.boardSize ||
        col < 0 ||
        col >= GameConstants.boardSize) {
      return null;
    }

    // セル内での相対座標
    final dx = x - col * cellSize;
    final dy = y - row * cellSize;

    // 最も近い辺の向きを取得
    final orientation = _getClosestOrientation(dx, dy, cellSize);
    if (orientation == null) return null;

    return BorderEdge(
      anchor: Position(row: row, col: col),
      orientation: orientation,
      owner: gameState.activePlayer.color,
    );
  }

  /// セル内の相対座標(dx, dy)から、最も近い辺の向きを判定する
  BorderOrientation? _getClosestOrientation(
    double dx,
    double dy,
    double cellSize,
  ) {
    final dists = {
      BorderOrientation.left: dx,
      BorderOrientation.right: cellSize - dx,
      BorderOrientation.top: dy,
      BorderOrientation.bottom: cellSize - dy,
    };

    // 最も距離が近い辺を探す
    final closest = dists.entries.reduce((a, b) => a.value < b.value ? a : b);

    // セルの中心付近（辺から遠い場合）は反応させない (閾値: セルサイズの30%)
    if (closest.value > cellSize * 0.3) return null;

    return closest.key;
  }

  Widget _buildPositioned({
    required Position position,
    required double cellSize,
    required Widget child,
  }) {
    return Positioned(
      left: position.col * cellSize,
      top: position.row * cellSize,
      width: cellSize,
      height: cellSize,
      child: child,
    );
  }
}
