import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';

import 'widgets/game_board_widget.dart';
import 'widgets/turn_indicator.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TurnIndicator(currentPlayer: gameState.currentTurn),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: GameBoardWidget(gameState: gameState),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(gameControllerProvider.notifier).endTurn();
        },
        label: const Text('End Turn'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
