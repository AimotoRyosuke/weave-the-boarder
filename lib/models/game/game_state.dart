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
  }) = _GameState;

  static GameState initial() {
    final board = Board.initial();
    final size = GameConstants.boardSize;
    final startPositions = {
      PlayerColor.white: const Position(row: 0, col: 0),
      PlayerColor.black: Position(row: size - 1, col: size - 1),
    };

    final players = startPositions.entries.map((entry) {
      return Player(color: entry.key, piecePosition: entry.value);
    }).toList();

    return GameState(
      board: board,
      players: players,
      currentTurn: PlayerColor.white,
    );
  }

    factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Player player(PlayerColor color) =>
      players.firstWhere((element) => element.color == color);

  Player get activePlayer => player(currentTurn);

  Player get waitingPlayer => player(currentTurn.opponent);
}
