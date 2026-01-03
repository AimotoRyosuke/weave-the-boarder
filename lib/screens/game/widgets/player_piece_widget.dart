import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/player_color.dart';

class PlayerPieceWidget extends StatelessWidget {
  const PlayerPieceWidget({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: player.color == PlayerColor.white ? Colors.white : Colors.black,
          shape: BoxShape.circle,
          border: player.color == PlayerColor.white
              ? Border.all(color: Colors.black, width: 2.0)
              : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            )
          ],
        ),
      ),
    );
  }
}
