import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/player_color.dart';

class BorderLineWidget extends StatelessWidget {
  const BorderLineWidget({
    super.key,
    this.edge,
    required this.orientation,
    this.onTap,
  });

  final BorderEdge? edge;
  final BorderOrientation orientation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = orientation == BorderOrientation.bottom;
    final color = edge != null ? _borderColor(edge!.owner) : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isHorizontal
            ? const EdgeInsets.symmetric(horizontal: 2.0)
            : const EdgeInsets.symmetric(vertical: 2.0),
        color: color,
        width: isHorizontal ? double.infinity : 4.0,
        height: isHorizontal ? 4.0 : double.infinity,
      ),
    );
  }

  Color _borderColor(PlayerColor owner) {
    return switch (owner) {
      PlayerColor.blue => Colors.blueGrey,
      PlayerColor.red => Colors.brown,
    };
  }
}
