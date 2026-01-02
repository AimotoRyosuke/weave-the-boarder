// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_token_stack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnergyTokenStack _$EnergyTokenStackFromJson(Map<String, dynamic> json) =>
    _EnergyTokenStack(
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EnergyTokenStackToJson(_EnergyTokenStack instance) =>
    <String, dynamic>{
      'position': instance.position.toJson(),
      'count': instance.count,
    };
