// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Player {

 PlayerColor get color; Position get piecePosition; int get remainingBorders; int get energy;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.color, color) || other.color == color)&&(identical(other.piecePosition, piecePosition) || other.piecePosition == piecePosition)&&(identical(other.remainingBorders, remainingBorders) || other.remainingBorders == remainingBorders)&&(identical(other.energy, energy) || other.energy == energy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,piecePosition,remainingBorders,energy);

@override
String toString() {
  return 'Player(color: $color, piecePosition: $piecePosition, remainingBorders: $remainingBorders, energy: $energy)';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 PlayerColor color, Position piecePosition, int remainingBorders, int energy
});


$PositionCopyWith<$Res> get piecePosition;

}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,Object? piecePosition = null,Object? remainingBorders = null,Object? energy = null,}) {
  return _then(_self.copyWith(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PlayerColor,piecePosition: null == piecePosition ? _self.piecePosition : piecePosition // ignore: cast_nullable_to_non_nullable
as Position,remainingBorders: null == remainingBorders ? _self.remainingBorders : remainingBorders // ignore: cast_nullable_to_non_nullable
as int,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get piecePosition {
  
  return $PositionCopyWith<$Res>(_self.piecePosition, (value) {
    return _then(_self.copyWith(piecePosition: value));
  });
}
}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayerColor color,  Position piecePosition,  int remainingBorders,  int energy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.color,_that.piecePosition,_that.remainingBorders,_that.energy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayerColor color,  Position piecePosition,  int remainingBorders,  int energy)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.color,_that.piecePosition,_that.remainingBorders,_that.energy);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayerColor color,  Position piecePosition,  int remainingBorders,  int energy)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.color,_that.piecePosition,_that.remainingBorders,_that.energy);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Player extends Player {
  const _Player({required this.color, required this.piecePosition, this.remainingBorders = GameConstants.borderTokensPerPlayer, this.energy = 0}): super._();
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override final  PlayerColor color;
@override final  Position piecePosition;
@override@JsonKey() final  int remainingBorders;
@override@JsonKey() final  int energy;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.color, color) || other.color == color)&&(identical(other.piecePosition, piecePosition) || other.piecePosition == piecePosition)&&(identical(other.remainingBorders, remainingBorders) || other.remainingBorders == remainingBorders)&&(identical(other.energy, energy) || other.energy == energy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,piecePosition,remainingBorders,energy);

@override
String toString() {
  return 'Player(color: $color, piecePosition: $piecePosition, remainingBorders: $remainingBorders, energy: $energy)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 PlayerColor color, Position piecePosition, int remainingBorders, int energy
});


@override $PositionCopyWith<$Res> get piecePosition;

}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,Object? piecePosition = null,Object? remainingBorders = null,Object? energy = null,}) {
  return _then(_Player(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PlayerColor,piecePosition: null == piecePosition ? _self.piecePosition : piecePosition // ignore: cast_nullable_to_non_nullable
as Position,remainingBorders: null == remainingBorders ? _self.remainingBorders : remainingBorders // ignore: cast_nullable_to_non_nullable
as int,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get piecePosition {
  
  return $PositionCopyWith<$Res>(_self.piecePosition, (value) {
    return _then(_self.copyWith(piecePosition: value));
  });
}
}

// dart format on
