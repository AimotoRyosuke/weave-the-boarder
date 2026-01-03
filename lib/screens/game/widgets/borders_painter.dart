import 'package:flutter/material.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/services/game/border_helper.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';

class BordersPainter extends CustomPainter {
  BordersPainter({
    required this.gameState,
    required this.cellSize,
    this.ruleService,
    this.actionType = ActionType.move,
    this.selectedEdges = const [],
    this.pendingEdges = const [],
  });

  final GameState gameState;
  final double cellSize;
  final GameRuleService? ruleService;
  final ActionType actionType;
  final List<BorderEdge> selectedEdges;
  final List<BorderEdge> pendingEdges;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw existing walls
    for (final edge in gameState.board.borders) {
      if (selectedEdges.contains(edge)) {
        borderPaint.color = Colors.amber;
        borderPaint.strokeWidth = 8.0;
      } else {
        borderPaint.color = _borderColor(edge.owner);
        borderPaint.strokeWidth = edge.isFortified ? 8.0 : 4.0;
      }
      _drawBorder(canvas, edge, borderPaint, gameState.board.borders);
    }

    // Draw pending wall (being dragged)
    if (pendingEdges.isNotEmpty) {
      final pendingPaint = Paint()
        ..strokeWidth = 8.0
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      for (final edge in pendingEdges) {
        _drawBorder(canvas, edge, pendingPaint, pendingEdges);
      }
    }

    // Draw placement hints and "X" marks
    if (ruleService != null) {
      final hintPaint = Paint()
        ..strokeWidth = 6.0
        ..style = PaintingStyle.stroke
        ..color = _borderColor(
          gameState.activePlayer.color,
        ).withValues(alpha: 0.2);

      final xPaint = Paint()
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..color = Colors.red.withValues(alpha: 0.6);

      if (actionType == ActionType.placeShortWall ||
          actionType == ActionType.placeLongWall ||
          (actionType == ActionType.relocateWall && selectedEdges.isNotEmpty)) {
        for (int row = 0; row < GameConstants.boardSize; row++) {
          for (int col = 0; col < GameConstants.boardSize; col++) {
            final pos = Position(row: row, col: col);
            for (final orientation in BorderOrientation.values) {
              final neighbor = pos.offset(orientation.dRow, orientation.dCol);
              if (!neighbor.isOnBoard) continue;

              // Only check each edge once to avoid double drawing
              if (pos.row > neighbor.row ||
                  (pos.row == neighbor.row && pos.col > neighbor.col)) {
                continue;
              }

              // Check if already occupied
              if (BorderHelper.hasBorderBetween(
                pos,
                neighbor,
                gameState.board.borders,
              )) {
                continue;
              }

              bool canPlaceAtLeastOne = false;

              if (actionType == ActionType.placeShortWall) {
                canPlaceAtLeastOne = ruleService!.canPlaceWall(
                  gameState,
                  pos,
                  orientation,
                );
              } else if (actionType == ActionType.relocateWall &&
                  selectedEdges.isNotEmpty) {
                if (selectedEdges.length == 1) {
                  canPlaceAtLeastOne = ruleService!.canRelocateWalls(
                    gameState,
                    selectedEdges,
                    [
                      BorderEdge(
                        anchor: pos,
                        orientation: orientation,
                        owner: gameState.activePlayer.color,
                      ),
                    ],
                  );
                } else {
                  // For 2nd wall relocation, try both extensions
                  final neighbors = [
                    (orientation == BorderOrientation.top ||
                            orientation == BorderOrientation.bottom)
                        ? pos.offset(0, 1)
                        : pos.offset(1, 0),
                    (orientation == BorderOrientation.top ||
                            orientation == BorderOrientation.bottom)
                        ? pos.offset(0, -1)
                        : pos.offset(-1, 0),
                  ];

                  for (final nextPos in neighbors) {
                    if (!nextPos.isOnBoard) continue;
                    final newEdges = [
                      BorderEdge(
                        anchor: pos,
                        orientation: orientation,
                        owner: gameState.activePlayer.color,
                      ),
                      BorderEdge(
                        anchor: nextPos,
                        orientation: orientation,
                        owner: gameState.activePlayer.color,
                      ),
                    ];
                    if (ruleService!.canRelocateWalls(
                      gameState,
                      selectedEdges,
                      newEdges,
                    )) {
                      canPlaceAtLeastOne = true;
                      break;
                    }
                  }
                }
              } else if (actionType == ActionType.placeLongWall) {
                // ... (existing long wall hint logic)
                final neighbors = [
                  (orientation == BorderOrientation.top ||
                          orientation == BorderOrientation.bottom)
                      ? pos.offset(0, 1)
                      : pos.offset(1, 0),
                  (orientation == BorderOrientation.top ||
                          orientation == BorderOrientation.bottom)
                      ? pos.offset(0, -1)
                      : pos.offset(-1, 0),
                ];

                for (final nextPos in neighbors) {
                  if (!nextPos.isOnBoard) continue;
                  final edges = [
                    BorderEdge(
                      anchor: pos,
                      orientation: orientation,
                      owner: gameState.activePlayer.color,
                    ),
                    BorderEdge(
                      anchor: nextPos,
                      orientation: orientation,
                      owner: gameState.activePlayer.color,
                    ),
                  ];
                  if (ruleService!.canPlaceLongWall(gameState, edges)) {
                    canPlaceAtLeastOne = true;
                    break;
                  }
                }
              }

              if (canPlaceAtLeastOne) {
                _drawBorder(
                  canvas,
                  BorderEdge(
                    anchor: pos,
                    orientation: orientation,
                    owner: PlayerColor.blue,
                  ),
                  hintPaint,
                  [],
                );
              } else if (actionType != ActionType.relocateWall) {
                // Skip X for relocate hints
                _drawX(canvas, pos, orientation, xPaint);
              }
            }
          }
        }
      }
    }
  }

  void _drawBorder(
    Canvas canvas,
    BorderEdge edge,
    Paint paint,
    List<BorderEdge> contextEdges,
  ) {
    double startX, startY, endX, endY;
    const insetSize = 4.0;

    final orientation = edge.orientation;
    final anchor = edge.anchor;

    // Determine if we should apply insets based on group connection
    bool hasConnectionStart = false;
    bool hasConnectionEnd = false;

    if (edge.groupId != null) {
      if (orientation == BorderOrientation.top ||
          orientation == BorderOrientation.bottom) {
        hasConnectionStart = contextEdges.any(
          (e) =>
              e.groupId == edge.groupId &&
              e.orientation == orientation &&
              e.anchor == anchor.offset(0, -1),
        );
        hasConnectionEnd = contextEdges.any(
          (e) =>
              e.groupId == edge.groupId &&
              e.orientation == orientation &&
              e.anchor == anchor.offset(0, 1),
        );
      } else {
        hasConnectionStart = contextEdges.any(
          (e) =>
              e.groupId == edge.groupId &&
              e.orientation == orientation &&
              e.anchor == anchor.offset(-1, 0),
        );
        hasConnectionEnd = contextEdges.any(
          (e) =>
              e.groupId == edge.groupId &&
              e.orientation == orientation &&
              e.anchor == anchor.offset(1, 0),
        );
      }
    }

    final startInset = hasConnectionStart ? 0.0 : insetSize;
    final endInset = hasConnectionEnd ? 0.0 : insetSize;

    switch (orientation) {
      case BorderOrientation.top:
        startX = anchor.col * cellSize + startInset;
        startY = anchor.row * cellSize;
        endX = (anchor.col + 1) * cellSize - endInset;
        endY = startY;
      case BorderOrientation.bottom:
        startX = anchor.col * cellSize + startInset;
        startY = (anchor.row + 1) * cellSize;
        endX = (anchor.col + 1) * cellSize - endInset;
        endY = startY;
      case BorderOrientation.left:
        startX = anchor.col * cellSize;
        startY = anchor.row * cellSize + startInset;
        endX = startX;
        endY = (anchor.row + 1) * cellSize - endInset;
      case BorderOrientation.right:
        startX = (anchor.col + 1) * cellSize;
        startY = anchor.row * cellSize + startInset;
        endX = startX;
        endY = (anchor.row + 1) * cellSize - endInset;
    }

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  void _drawX(
    Canvas canvas,
    Position anchor,
    BorderOrientation orientation,
    Paint paint,
  ) {
    Offset center;
    switch (orientation) {
      case BorderOrientation.top:
        center = Offset((anchor.col + 0.5) * cellSize, anchor.row * cellSize);
      case BorderOrientation.bottom:
        center = Offset(
          (anchor.col + 0.5) * cellSize,
          (anchor.row + 1) * cellSize,
        );
      case BorderOrientation.left:
        center = Offset(anchor.col * cellSize, (anchor.row + 0.5) * cellSize);
      case BorderOrientation.right:
        center = Offset(
          (anchor.col + 1) * cellSize,
          (anchor.row + 0.5) * cellSize,
        );
    }

    const size = 4.0;
    canvas.drawLine(
      center + const Offset(-size, -size),
      center + const Offset(size, size),
      paint,
    );
    canvas.drawLine(
      center + const Offset(size, -size),
      center + const Offset(-size, size),
      paint,
    );
  }

  @override
  bool shouldRepaint(BordersPainter oldDelegate) {
    return true;
  }

  Color _borderColor(PlayerColor owner) {
    return owner.darkColor;
  }
}
