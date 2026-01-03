import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';

import 'board_cell_widget.dart';
import 'borders_painter.dart';
import 'energy_token_widget.dart';
import 'player_piece_widget.dart';

class GameBoardWidget extends ConsumerWidget {
  const GameBoardWidget({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const ruleService = GameRuleService();

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth;
        final cellSize = boardSize / GameConstants.boardSize;
        const tapAreaWidth = 10.0; // Width of the tappable area for borders

        return Stack(
          children: [
            // Grid of cells
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: GameConstants.boardSize,
              ),
              itemCount: GameConstants.boardSize * GameConstants.boardSize,
              itemBuilder: (context, index) {
                final position = gameState.board.positionFromIndex(index);
                final cell = gameState.board.cellAt(position);
                final isMovable = ruleService.canMove(gameState, position);

                return BoardCellWidget(
                  cell: cell,
                  isMovable: isMovable,
                  onTapDown: (details) {
                    final dxInCell = details.localPosition.dx;
                    final dyInCell = details.localPosition.dy;

                    bool actionTaken = false;
                    if (dxInCell < tapAreaWidth) {
                      if (ruleService.canPlaceBorder(
                        gameState,
                        position,
                        BorderOrientation.left,
                      )) {
                        ref
                            .read(gameControllerProvider.notifier)
                            .placeBorder(position, BorderOrientation.left);
                        actionTaken = true;
                      }
                    } else if (dxInCell > cellSize - tapAreaWidth) {
                      if (ruleService.canPlaceBorder(
                        gameState,
                        position,
                        BorderOrientation.right,
                      )) {
                        ref
                            .read(gameControllerProvider.notifier)
                            .placeBorder(position, BorderOrientation.right);
                        actionTaken = true;
                      }
                    }

                    if (!actionTaken && dyInCell < tapAreaWidth) {
                      if (ruleService.canPlaceBorder(
                        gameState,
                        position,
                        BorderOrientation.top,
                      )) {
                        ref
                            .read(gameControllerProvider.notifier)
                            .placeBorder(position, BorderOrientation.top);
                        actionTaken = true;
                      }
                    } else if (!actionTaken &&
                        dyInCell > cellSize - tapAreaWidth) {
                      if (ruleService.canPlaceBorder(
                        gameState,
                        position,
                        BorderOrientation.bottom,
                      )) {
                        ref
                            .read(gameControllerProvider.notifier)
                            .placeBorder(position, BorderOrientation.bottom);
                        actionTaken = true;
                      }
                    }

                    if (!actionTaken) {
                      if (ruleService.canMove(gameState, position)) {
                        ref
                            .read(gameControllerProvider.notifier)
                            .movePiece(position);
                      }
                    }
                  },
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),

            // Borders
            IgnorePointer(
              child: CustomPaint(
                size: Size(boardSize, boardSize),
                painter: BordersPainter(
                  gameState: gameState,
                  cellSize: cellSize,
                  ruleService: ruleService,
                ),
              ),
            ),

            // Player pieces
            ...gameState.players.map((player) {
              return _buildPositioned(
                position: player.piecePosition,
                cellSize: cellSize,
                child: IgnorePointer(
                  child: PlayerPieceWidget(
                    key: ValueKey(player.color), // Add key for testing
                    player: player,
                  ),
                ),
              );
            }),

            // Energy tokens
            ...gameState.board.energyStacks.map((stack) {
              if (!stack.hasTokens) return const SizedBox.shrink();
              return _buildPositioned(
                position: stack.position,
                cellSize: cellSize,
                child: EnergyTokenWidget(
                  stack: stack,
                  onTap: () {
                    ref
                        .read(gameControllerProvider.notifier)
                        .collectEnergy(stack.position);
                  },
                ),
              );
            }),
          ],
        );
      },
    );
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
