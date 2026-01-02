import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';
import 'package:weave_the_border/services/game/score_calculator.dart';

part 'game_controller_provider.g.dart';

@riverpod
class GameController extends _$GameController {
  final GameRuleService _ruleService = const GameRuleService();

  @override
  GameState build() => GameState.initial();

  void resetGame() => state = GameState.initial();

  void movePiece(Position destination) =>
      state = _ruleService.movePiece(state, destination);

  void placeBorder(Position anchor, BorderOrientation orientation) =>
      state = _ruleService.placeBorder(state, anchor, orientation);

  void collectEnergy(Position energyPosition) =>
      state = _ruleService.collectEnergy(state, energyPosition);

  void specialMove(Position destination) =>
      state = _ruleService.specialMove(state, destination);

  void breakBorder(BorderEdge edge) =>
      state = _ruleService.breakBorder(state, edge);

  void fortifyArea(Set<Position> area) =>
      state = _ruleService.fortifyArea(state, area);

  void passTurn() => state = _ruleService.passTurn(state);

  void endTurn() => state = _ruleService.endTurn(state);

  Map<PlayerColor, ScoreDetail> currentScore() => _ruleService.score(state);

  ScoreDetail scoreFor(PlayerColor color) => _ruleService.detail(state, color);
}
