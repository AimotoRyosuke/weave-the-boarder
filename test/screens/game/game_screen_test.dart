import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/screens/game/game_screen.dart';
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
      hasTakenBasicAction: true,
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
        child: const MaterialApp(home: GameScreen()),
      ),
    );

    // Wait for the widgets to build
    await tester.pumpAndSettle();

    // Verify that two player pieces are on the board
    expect(find.byType(PlayerPieceWidget), findsNWidgets(2));

    // Verify that one energy token stack is on the board
    expect(find.byType(EnergyTokenWidget), findsOneWidget);

    // Verify the energy token count
    final energyFinder = find.descendant(
      of: find.byType(EnergyTokenWidget),
      matching: find.text(GameConstants.initialCenterEnergy.toString()),
    );
    expect(energyFinder, findsOneWidget);
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
        child: const MaterialApp(home: GameScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Initial position of white player is (0, 0)
    expect(
      container.read(gameControllerProvider).activePlayer.piecePosition,
      const Position(row: 0, col: 0),
    );

    // Find the cell at (1, 0) and tap it
    final cellToTap = find.byWidgetPredicate(
      (widget) =>
          widget is BoardCellWidget &&
          widget.cell.position == const Position(row: 1, col: 0),
    );
    expect(cellToTap, findsOneWidget);
    await tester.tap(cellToTap);
    await tester.pumpAndSettle();

    // Verify the player has moved
    expect(
      container.read(gameControllerProvider).activePlayer.piecePosition,
      const Position(row: 1, col: 0),
    );
  });

  testWidgets('Cannot move twice in the same turn', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: GameScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Move from (0,0) to (1,0)
    final cell1 = find.byWidgetPredicate(
      (widget) =>
          widget is BoardCellWidget &&
          widget.cell.position == const Position(row: 1, col: 0),
    );
    await tester.tap(cell1);
    await tester.pumpAndSettle();

    expect(
      container.read(gameControllerProvider).activePlayer.piecePosition,
      const Position(row: 1, col: 0),
    );
    expect(container.read(gameControllerProvider).hasTakenBasicAction, isTrue);

    // Try to move again to (2,0)
    final cell2 = find.byWidgetPredicate(
      (widget) =>
          widget is BoardCellWidget &&
          widget.cell.position == const Position(row: 2, col: 0),
    );
    // Note: The real GameController would throw an exception, but our Mock might behave differently.
    // However, the BoardCellWidget's isMovable hint should now be false.
    final cell2Widget = tester.widget<BoardCellWidget>(cell2);
    expect(cell2Widget.isMovable, isFalse);

    // If we use the real controller (by not overriding), it would throw.
    // Let's check if the tap actually changes anything.
    await tester.tap(cell2);
    await tester.pumpAndSettle();

    // Position should still be (1,0)
    expect(
      container.read(gameControllerProvider).activePlayer.piecePosition,
      const Position(row: 1, col: 0),
    );
  });
}
