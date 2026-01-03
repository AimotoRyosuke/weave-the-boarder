// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cell _$CellFromJson(Map<String, dynamic> json) => _Cell(
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
  owner: $enumDecodeNullable(_$PlayerColorEnumMap, json['owner']),
);

Map<String, dynamic> _$CellToJson(_Cell instance) => <String, dynamic>{
  'position': instance.position.toJson(),
  'owner': _$PlayerColorEnumMap[instance.owner],
};

const _$PlayerColorEnumMap = {PlayerColor.blue: 'blue', PlayerColor.red: 'red'};
