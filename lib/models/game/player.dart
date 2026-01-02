import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
sealed class Player with _$Player {
  const Player._();
  @JsonSerializable(explicitToJson: true)
  const factory Player({
    required PlayerColor color,
    required Position piecePosition,
    @Default(GameConstants.borderTokensPerPlayer) int remainingBorders,
    @Default(0) int energy,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  bool get isOnBoard => piecePosition.isOnBoard;
}
