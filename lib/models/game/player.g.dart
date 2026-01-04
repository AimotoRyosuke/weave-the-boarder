// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  color: $enumDecode(_$PlayerColorEnumMap, json['color']),
  piecePosition: Position.fromJson(
    json['piecePosition'] as Map<String, dynamic>,
  ),
  shortWalls:
      (json['shortWalls'] as num?)?.toInt() ??
      GameConstants.shortWallTokensPerPlayer,
  longWalls:
      (json['longWalls'] as num?)?.toInt() ??
      GameConstants.longWallTokensPerPlayer,
  energy: (json['energy'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'color': _$PlayerColorEnumMap[instance.color]!,
  'piecePosition': instance.piecePosition.toJson(),
  'shortWalls': instance.shortWalls,
  'longWalls': instance.longWalls,
  'energy': instance.energy,
};

const _$PlayerColorEnumMap = {PlayerColor.blue: 'blue', PlayerColor.red: 'red'};
