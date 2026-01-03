import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/player_color.dart';

class TurnIndicator extends StatelessWidget {
  const TurnIndicator({super.key, required this.currentPlayer});

  final PlayerColor currentPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Turn: ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            currentPlayer.displayName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: currentPlayer == PlayerColor.white
                      ? Colors.black
                      : Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
