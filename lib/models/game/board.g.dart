// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Board _$BoardFromJson(Map<String, dynamic> json) => _Board(
  cells: (json['cells'] as List<dynamic>)
      .map((e) => Cell.fromJson(e as Map<String, dynamic>))
      .toList(),
  borders:
      (json['borders'] as List<dynamic>?)
          ?.map((e) => BorderEdge.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  energyStacks: (json['energyStacks'] as List<dynamic>)
      .map((e) => EnergyTokenStack.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BoardToJson(_Board instance) => <String, dynamic>{
  'cells': instance.cells.map((e) => e.toJson()).toList(),
  'borders': instance.borders.map((e) => e.toJson()).toList(),
  'energyStacks': instance.energyStacks.map((e) => e.toJson()).toList(),
};
