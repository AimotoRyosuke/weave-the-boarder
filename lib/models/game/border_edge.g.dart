// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border_edge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BorderEdge _$BorderEdgeFromJson(Map<String, dynamic> json) => _BorderEdge(
  anchor: Position.fromJson(json['anchor'] as Map<String, dynamic>),
  orientation: $enumDecode(_$BorderOrientationEnumMap, json['orientation']),
  owner: $enumDecode(_$PlayerColorEnumMap, json['owner']),
  isFortified: json['isFortified'] as bool? ?? false,
);

Map<String, dynamic> _$BorderEdgeToJson(_BorderEdge instance) =>
    <String, dynamic>{
      'anchor': instance.anchor.toJson(),
      'orientation': _$BorderOrientationEnumMap[instance.orientation]!,
      'owner': _$PlayerColorEnumMap[instance.owner]!,
      'isFortified': instance.isFortified,
    };

const _$BorderOrientationEnumMap = {
  BorderOrientation.top: 'top',
  BorderOrientation.right: 'right',
  BorderOrientation.bottom: 'bottom',
  BorderOrientation.left: 'left',
};

const _$PlayerColorEnumMap = {
  PlayerColor.white: 'white',
  PlayerColor.black: 'black',
};
