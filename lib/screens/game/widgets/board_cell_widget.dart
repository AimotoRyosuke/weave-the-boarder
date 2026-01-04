import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/player_color.dart';

class BoardCellWidget extends StatelessWidget {
  const BoardCellWidget({super.key, required this.cell});

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cellColor(cell.owner) ?? Colors.transparent,
        border: Border.all(color: Colors.grey.shade400),
      ),
    );
  }

  Color? _cellColor(PlayerColor? owner) {
    return owner?.color;
  }
}
