import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';

class PlayerStatusWidget extends StatelessWidget {
  const PlayerStatusWidget({
    super.key,
    required this.player,
    required this.score,
    required this.isActive,
  });

  final Player player;
  final ScoreDetail score;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PlayerCircle(playerColor: player.color),
              const Gap(4),
              Text(
                player.color.displayName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              Text(
                '${score.territoryCount}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '/${GameConstants.cellsToWin}マス',
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Gap(4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusItem(
                icon: Icons.bolt,
                value: player.energy.toString(),
                iconColor: Colors.amber,
              ),
              const SizedBox(width: 8),
              _StatusItem(
                icon: Icons.remove,
                value: player.shortWalls.toString(),
              ),
              const SizedBox(width: 4),
              _StatusItem(
                icon: Icons.reorder,
                value: player.longWalls.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.icon,
    required this.value,
    this.iconColor = Colors.blueGrey,
  });

  final IconData icon;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PlayerCircle extends StatelessWidget {
  const _PlayerCircle({required this.playerColor});

  final PlayerColor playerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: playerColor.darkColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
