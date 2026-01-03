import 'package:flutter/material.dart';
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
        border: isActive
            ? Border.all(color: colorScheme.primary, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlayerCircle(player.color),
              const SizedBox(width: 8),
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
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStat(
                Icons.terrain,
                '${score.territoryCount}/${GameConstants.cellsToWin}',
              ),
              const SizedBox(width: 8),
              _buildStat(
                Icons.bolt,
                player.energy.toString(),
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              _buildStat(Icons.remove, player.shortWalls.toString()),
              const SizedBox(width: 4),
              _buildStat(Icons.reorder, player.longWalls.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCircle(PlayerColor playerColor) {
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

  Widget _buildStat(IconData icon, String value, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.blueGrey),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
