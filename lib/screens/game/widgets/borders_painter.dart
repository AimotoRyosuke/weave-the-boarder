import 'package:flutter/material.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';

class BordersPainter extends CustomPainter {
  BordersPainter({
    required this.gameState,
    required this.cellSize,
    this.ruleService,
  });

  final GameState gameState;
  final double cellSize;
  final GameRuleService? ruleService;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw existing borders
    for (final edge in gameState.board.borders) {
      borderPaint.color = _borderColor(edge.owner);
      _drawBorder(canvas, edge.anchor, edge.orientation, borderPaint);
    }

    // Draw placement hints
    if (ruleService != null) {
      final hintPaint = Paint()
        ..strokeWidth = 6.0 // Slightly thicker to be visible behind the tap area
        ..style = PaintingStyle.stroke
        ..color = _borderColor(gameState.activePlayer.color).withOpacity(0.2);

      for (int row = 0; row < GameConstants.boardSize; row++) {
        for (int col = 0; col < GameConstants.boardSize; col++) {
          final pos = Position(row: row, col: col);
          for (final orientation in BorderOrientation.values) {
            if (ruleService!.canPlaceBorder(gameState, pos, orientation)) {
              _drawBorder(canvas, pos, orientation, hintPaint);
            }
          }
        }
      }
    }
  }

  void _drawBorder(
    Canvas canvas,
    Position anchor,
    BorderOrientation orientation,
    Paint paint,
  ) {
    double startX, startY, endX, endY;

    switch (orientation) {
      case BorderOrientation.top:
        startX = anchor.col * cellSize;
        startY = anchor.row * cellSize;
        endX = (anchor.col + 1) * cellSize;
        endY = startY;
      case BorderOrientation.bottom:
        startX = anchor.col * cellSize;
        startY = (anchor.row + 1) * cellSize;
        endX = (anchor.col + 1) * cellSize;
        endY = startY;
      case BorderOrientation.left:
        startX = anchor.col * cellSize;
        startY = anchor.row * cellSize;
        endX = startX;
        endY = (anchor.row + 1) * cellSize;
      case BorderOrientation.right:
        startX = (anchor.col + 1) * cellSize;
        startY = anchor.row * cellSize;
        endX = startX;
        endY = (anchor.row + 1) * cellSize;
    }

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // For simplicity, always repaint.
  }

  Color _borderColor(PlayerColor owner) {
    return switch (owner) {
      PlayerColor.white => Colors.blueGrey,
      PlayerColor.black => Colors.brown,
    };
  }
}
