import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/providers/game/action_provider.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';

part 'game_controller_provider.g.dart';

@riverpod
class GameController extends _$GameController {
  final GameRuleService _ruleService = const GameRuleService();

  @override
  GameState build() => GameState.initial();

  void resetGame() => state = GameState.initial();

  void movePiece(Position destination) {
    state = _ruleService.movePiece(state, destination);
    _checkAutoEndTurn();
  }

  void placeWall(Position anchor, BorderOrientation orientation) {
    state = _ruleService.placeWall(state, anchor, orientation);
    _checkAutoEndTurn();
  }

  void placeLongWall(List<BorderEdge> edges) {
    state = _ruleService.placeLongWall(state, edges);
    _checkAutoEndTurn();
  }

  void relocateWalls(
    List<BorderEdge> oldEdges,
    List<BorderEdge> newEdges,
  ) {
    state = _ruleService.relocateWalls(state, oldEdges, newEdges);
    _checkAutoEndTurn();
  }

  void useDoubleMove(Position target) {
    state = _ruleService.useDoubleMove(state, target);
    _checkAutoEndTurn();
  }

  void passAction() {
    state = _ruleService.passAction(state);
    _checkAutoEndTurn();
  }

  void endTurn() => state = _ruleService.endTurn(state);

  void _checkAutoEndTurn() {
    if (state.actionsRemaining <= 0) {
      endTurn();
      ref.read(actionProvider.notifier).reset();
    }
  }

  Map<PlayerColor, ScoreDetail> currentScore() => const ScoreCalculator().evaluate(state);

  ScoreDetail scoreFor(PlayerColor color) =>
      const ScoreCalculator().evaluate(state)[color]!;
}
