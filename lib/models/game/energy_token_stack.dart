import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/models/game/position.dart';

part 'energy_token_stack.freezed.dart';
part 'energy_token_stack.g.dart';

@freezed
sealed class EnergyTokenStack with _$EnergyTokenStack {
  const EnergyTokenStack._();
  @JsonSerializable(explicitToJson: true)
  const factory EnergyTokenStack({
    required Position position,
    @Default(0) int count,
  }) = _EnergyTokenStack;

  factory EnergyTokenStack.fromJson(Map<String, dynamic> json) =>
      _$EnergyTokenStackFromJson(json);

  bool get hasTokens => count > 0;

  int tokensAdjacent(Position other) =>
      hasTokens && position == other ? count : 0;
}
