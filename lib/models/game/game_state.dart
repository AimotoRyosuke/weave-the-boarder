import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
sealed class GameState with _$GameState {
  const GameState._();
  @JsonSerializable(explicitToJson: true)
  const factory GameState({
    required Board board,
    required List<Player> players,
    required PlayerColor currentTurn,
    @Default(0) int turnCount,
    @Default(GameConstants.actionsPerTurn) int actionsRemaining,
  }) = _GameState;

  static GameState initial() {
    final board = Board.initial();

    final players = [
      const Player(
        color: PlayerColor.blue,
        piecePosition: Position(row: 6, col: 3),
        energy: 0,
      ),
      const Player(
        color: PlayerColor.red,
        piecePosition: Position(row: 0, col: 3),
        energy: 0, // Both players start with 0 energy
      ),
    ];

    return GameState(
      board: board,
      players: players,
      currentTurn: PlayerColor.blue,
      actionsRemaining: GameConstants.actionsPerTurn,
    );
  }

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Player player(PlayerColor color) =>
      players.firstWhere((element) => element.color == color);

  Player get activePlayer => player(currentTurn);

  Player get waitingPlayer => player(currentTurn.opponent);
}
