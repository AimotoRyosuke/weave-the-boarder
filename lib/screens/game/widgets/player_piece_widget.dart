import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/player.dart';

class PlayerPieceWidget extends StatelessWidget {
  const PlayerPieceWidget({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: player.color.darkColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
