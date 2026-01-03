import 'package:flutter/material.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/position.dart';

import 'board_cell_widget.dart';
import 'energy_token_widget.dart';
import 'player_piece_widget.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth;
        final cellSize = boardSize / GameConstants.boardSize;

        return SizedBox(
          width: boardSize,
          height: boardSize,
          child: Stack(
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
                  return BoardCellWidget(cell: cell);
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),

              // Player pieces
              ...gameState.players.map((player) {
                return _buildPositioned(
                  position: player.piecePosition,
                  cellSize: cellSize,
                  child: PlayerPieceWidget(player: player),
                );
              }),

              // Energy tokens
              ...gameState.board.energyStacks.map((stack) {
                return _buildPositioned(
                  position: stack.position,
                  cellSize: cellSize,
                  child: EnergyTokenWidget(stack: stack),
                );
              }),
            ],
          ),
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
