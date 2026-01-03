import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/screens/game/game_screen.dart';
import 'package:weave_the_border/screens/game/widgets/energy_token_widget.dart';
import 'package:weave_the_border/screens/game/widgets/player_piece_widget.dart';

// A mock controller for testing purposes
class MockGameController extends GameController {
  @override
  GameState build() {
    return GameState.initial();
  }
}

void main() {
  testWidgets('GameScreen should display initial setup correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameControllerProvider.overrideWith(() => MockGameController()),
        ],
        child: const MaterialApp(
          home: GameScreen(),
        ),
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
}
