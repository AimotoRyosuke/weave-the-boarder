// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  board: Board.fromJson(json['board'] as Map<String, dynamic>),
  players: (json['players'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentTurn: $enumDecode(_$PlayerColorEnumMap, json['currentTurn']),
  turnCount: (json['turnCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'board': instance.board.toJson(),
      'players': instance.players.map((e) => e.toJson()).toList(),
      'currentTurn': _$PlayerColorEnumMap[instance.currentTurn]!,
      'turnCount': instance.turnCount,
    };

const _$PlayerColorEnumMap = {
  PlayerColor.white: 'white',
  PlayerColor.black: 'black',
};
