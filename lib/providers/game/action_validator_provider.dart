import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/models/game/game_state.dart';
import 'package:weave_the_border/providers/game/game_controller_provider.dart';
import 'package:weave_the_border/services/game/game_rule_service.dart';

part 'action_validator_provider.g.dart';

@riverpod
GameActionValidator actionValidator(Ref ref) =>
    GameActionValidator(ref, const GameRuleService());

class GameActionValidator {
  GameActionValidator(this._ref, this.ruleService);

  final Ref _ref;
  final GameRuleService ruleService;

  GameState get _state => _ref.read(gameControllerProvider);

  bool canMove(Position destination) =>
      ruleService.canMove(_state, destination);

  bool canPlaceWall(Position anchor, BorderOrientation orientation) =>
      ruleService.canPlaceWall(_state, anchor, orientation);

  bool canPlaceLongWall(List<BorderEdge> edges) =>
      ruleService.canPlaceLongWall(_state, edges);

  bool canUseDoubleMove(Position destination) =>
      ruleService.canUseDoubleMove(_state, destination);
}
