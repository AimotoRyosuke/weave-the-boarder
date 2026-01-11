import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/providers/game/action_provider.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';
import 'package:weave_the_border/widgets/decision_dialog.dart';

import 'package:weave_the_border/screens/game/widgets/game_board_widget.dart';
import 'package:weave_the_border/screens/game/widgets/player_status_widget.dart';
import 'package:weave_the_border/screens/game/widgets/action_selector.dart';
import 'package:weave_the_border/screens/game/widgets/turn_indicator.dart';

class LocalGameScreen extends HookConsumerWidget {
  const LocalGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowPop = useState(false);
    final gameState = ref.watch(gameControllerProvider);
    final currentAction = ref.watch(actionProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final scores = controller.currentScore();

    final winner = const ScoreCalculator().winner(gameState);
    if (winner != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(context, ref, winner, scores);
      });
    }

    // Check if 'Pass' is required (no valid moves in current movement mode)
    const ruleService = GameRuleService();
    bool hasAnyMove = false;
    if (currentAction.type == ActionType.move ||
        currentAction.type == ActionType.doubleMove) {
      for (int row = 0; row < GameConstants.boardSize; row++) {
        for (int col = 0; col < GameConstants.boardSize; col++) {
          final pos = Position(row: row, col: col);
          final canMove = (currentAction.type == ActionType.move)
              ? ruleService.canMove(gameState, pos)
              : ruleService.canUseDoubleMove(gameState, pos);
          if (canMove) {
            hasAnyMove = true;
            break;
          }
        }
        if (hasAnyMove) break;
      }
    }

    final showPass =
        (currentAction.type == ActionType.move ||
            currentAction.type == ActionType.doubleMove) &&
        !hasAnyMove &&
        winner == null;

    return PopScope(
      canPop: allowPop.value,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const BackButtonIcon(),
            onPressed: () async {
              final navigator = Navigator.of(context);
              allowPop.value = (await _showExitConfirmation(context)) ?? false;
              if (allowPop.value) {
                navigator.pop();
              }
            },
          ),
          title: TurnIndicator(currentPlayer: gameState.currentTurn),
        ),
        body: SafeArea(
          child: IgnorePointer(
            ignoring: winner != null,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlayerStatusWidget(
                        player: gameState.player(PlayerColor.blue),
                        score: scores[PlayerColor.blue]!,
                        isActive: gameState.currentTurn == PlayerColor.blue,
                      ),
                      PlayerStatusWidget(
                        player: gameState.player(PlayerColor.red),
                        score: scores[PlayerColor.red]!,
                        isActive: gameState.currentTurn == PlayerColor.red,
                      ),
                    ],
                  ),
                ),
                const ActionSelector(),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: GameBoardWidget(gameState: gameState),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: showPass
            ? FloatingActionButton.extended(
                onPressed: () => controller.passAction(),
                label: const Text('パスする'),
                icon: const Icon(Icons.skip_next),
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) {
    return DecisionDialog.show<bool>(
      context,
      title: '決戦を終えますか？',
      content: '現在の戦況は失われます。\n\nそれでも退却しますか？',
      cancelLabel: '戦場に戻る',
      confirmLabel: '退却する',
      onCancel: () => Navigator.of(context).pop(false),
      onConfirm: () => Navigator.of(context).pop(true),
    );
  }

  void _showGameOverDialog(
    BuildContext context,
    WidgetRef ref,
    PlayerColor winner,
    Map<PlayerColor, ScoreDetail> scores,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('対局終了', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${winner.displayName}の勝利！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: winner.darkColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '青: ${scores[PlayerColor.blue]!.territoryCount}マス',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '赤: ${scores[PlayerColor.red]!.territoryCount}マス',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              child: const Text('やめる'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(gameControllerProvider.notifier).resetGame();
              },
              child: const Text('もう一度'),
            ),
          ],
        );
      },
    );
  }
}
