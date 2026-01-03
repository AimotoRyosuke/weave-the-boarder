import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/player_color.dart';

class BoardCellWidget extends StatelessWidget {
  const BoardCellWidget({
    super.key,
    required this.cell,
    this.onTapDown,
    this.isMovable = false,
  });

  final Cell cell;
  final Function(TapDownDetails)? onTapDown;
  final bool isMovable;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cellColor(cell.owner) ?? Colors.transparent,
      child: InkWell(
        onTapDown: onTapDown,
        onTap: () {}, // Needed to enable the InkWell and ripple
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: isMovable
              ? Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Color? _cellColor(PlayerColor? owner) {
    return switch (owner) {
      PlayerColor.white => Colors.grey.shade200,
      PlayerColor.black => Colors.grey.shade600,
      null => null,
    };
  }
}
