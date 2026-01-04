import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/screens/game/local_game_screen.dart';
import 'package:weave_the_border/screens/game/widgets/board_cell_widget.dart';
import 'package:weave_the_border/screens/game/widgets/energy_token_widget.dart';
import 'package:weave_the_border/screens/game/widgets/player_piece_widget.dart';

// A mock controller for testing purposes
class MockGameController extends GameController {
  @override
  GameState build() {
    return GameState.initial();
  }

  @override
  void movePiece(Position destination) {
    state = state.copyWith(
      actionsRemaining: state.actionsRemaining - 1,
      players: state.players.map((p) {
        if (p.color == state.currentTurn) {
          return p.copyWith(piecePosition: destination);
        }
        return p;
      }).toList(),
    );
  }
}

void main() {
  testWidgets('GameScreen should display initial setup correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameControllerProvider.overrideWith(() => MockGameController()),
        ],
        child: const MaterialApp(home: LocalGameScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // 2 player pieces
    expect(find.byType(PlayerPieceWidget), findsNWidgets(2));

    // 5 energy token stacks
    expect(find.byType(EnergyTokenWidget), findsNWidgets(5));
  });

  testWidgets('Tapping a cell moves the player piece', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        gameControllerProvider.overrideWith(() => MockGameController()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LocalGameScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Initial position of blue player is (6, 3)
    expect(
      container.read(gameControllerProvider).activePlayer.piecePosition,
      const Position(row: 6, col: 3),
    );

    // Tap adjacent cell (5, 3)
    final cellToTap = find.byWidgetPredicate(
      (widget) =>
          widget is BoardCellWidget &&
          widget.cell.position == const Position(row: 5, col: 3),
    );
    expect(cellToTap, findsOneWidget);
    await tester.tap(cellToTap);
    await tester.pumpAndSettle();

    expect(
      container.read(gameControllerProvider).activePlayer.piecePosition,
      const Position(row: 5, col: 3),
    );
  });
}
