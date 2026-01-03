import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/providers/game/action_provider.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';

class ActionSelector extends ConsumerWidget {
  const ActionSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAction = ref.watch(actionProvider);
    final notifier = ref.read(actionProvider.notifier);
    final gameState = ref.watch(gameControllerProvider);
    final hasEnergy = gameState.activePlayer.energy > 0;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _ActionChip(
          label: '移動',
          icon: Icons.directions_run,
          cost: 0,
          isSelected: selectedAction.type == ActionType.move,
          onTap: () => notifier.select(ActionType.move),
        ),
        _ActionChip(
          label: '1マス壁',
          icon: Icons.remove,
          cost: 0,
          isSelected: selectedAction.type == ActionType.placeShortWall,
          onTap: () => notifier.select(ActionType.placeShortWall),
        ),
        _ActionChip(
          label: '2マス壁',
          icon: Icons.reorder,
          cost: 0,
          isSelected: selectedAction.type == ActionType.placeLongWall,
          onTap: () => notifier.select(ActionType.placeLongWall),
        ),
        _ActionChip(
          label: '2マス移動',
          icon: Icons.bolt,
          cost: 1,
          isSelected: selectedAction.type == ActionType.doubleMove,
          isEnabled: hasEnergy,
          onTap: () => notifier.select(ActionType.doubleMove),
        ),
        _ActionChip(
          label: '壁移動',
          icon: Icons.move_up,
          cost: 1,
          isSelected: selectedAction.type == ActionType.relocateWall,
          isEnabled: hasEnergy,
          onTap: () => notifier.select(ActionType.relocateWall),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.cost,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  }) : isSpecial = cost > 0;

  final String label;
  final IconData icon;
  final int cost;
  final bool isSelected;
  final bool isEnabled;
  final bool isSpecial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    Color foregroundColor = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    if (!isEnabled) {
      backgroundColor = colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      );
      foregroundColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    } else if (isSpecial && !isSelected) {
      foregroundColor = Colors.amber.shade900;
    }

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: foregroundColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
            if (cost > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.onPrimary.withValues(alpha: 0.2)
                      : (isEnabled ? Colors.amber : Colors.grey).withValues(
                          alpha: 0.2,
                        ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$cost',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : (isEnabled ? Colors.amber.shade800 : Colors.grey),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
