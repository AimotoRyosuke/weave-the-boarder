// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'energy_token_stack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnergyTokenStack {

 Position get position; int get count;
/// Create a copy of EnergyTokenStack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnergyTokenStackCopyWith<EnergyTokenStack> get copyWith => _$EnergyTokenStackCopyWithImpl<EnergyTokenStack>(this as EnergyTokenStack, _$identity);

  /// Serializes this EnergyTokenStack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnergyTokenStack&&(identical(other.position, position) || other.position == position)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,count);

@override
String toString() {
  return 'EnergyTokenStack(position: $position, count: $count)';
}


}

/// @nodoc
abstract mixin class $EnergyTokenStackCopyWith<$Res>  {
  factory $EnergyTokenStackCopyWith(EnergyTokenStack value, $Res Function(EnergyTokenStack) _then) = _$EnergyTokenStackCopyWithImpl;
@useResult
$Res call({
 Position position, int count
});


$PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$EnergyTokenStackCopyWithImpl<$Res>
    implements $EnergyTokenStackCopyWith<$Res> {
  _$EnergyTokenStackCopyWithImpl(this._self, this._then);

  final EnergyTokenStack _self;
  final $Res Function(EnergyTokenStack) _then;

/// Create a copy of EnergyTokenStack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? count = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EnergyTokenStack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [EnergyTokenStack].
extension EnergyTokenStackPatterns on EnergyTokenStack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnergyTokenStack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnergyTokenStack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnergyTokenStack value)  $default,){
final _that = this;
switch (_that) {
case _EnergyTokenStack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnergyTokenStack value)?  $default,){
final _that = this;
switch (_that) {
case _EnergyTokenStack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Position position,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnergyTokenStack() when $default != null:
return $default(_that.position,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Position position,  int count)  $default,) {final _that = this;
switch (_that) {
case _EnergyTokenStack():
return $default(_that.position,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Position position,  int count)?  $default,) {final _that = this;
switch (_that) {
case _EnergyTokenStack() when $default != null:
return $default(_that.position,_that.count);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EnergyTokenStack extends EnergyTokenStack {
  const _EnergyTokenStack({required this.position, this.count = 0}): super._();
  factory _EnergyTokenStack.fromJson(Map<String, dynamic> json) => _$EnergyTokenStackFromJson(json);

@override final  Position position;
@override@JsonKey() final  int count;

/// Create a copy of EnergyTokenStack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnergyTokenStackCopyWith<_EnergyTokenStack> get copyWith => __$EnergyTokenStackCopyWithImpl<_EnergyTokenStack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnergyTokenStackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnergyTokenStack&&(identical(other.position, position) || other.position == position)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,count);

@override
String toString() {
  return 'EnergyTokenStack(position: $position, count: $count)';
}


}

/// @nodoc
abstract mixin class _$EnergyTokenStackCopyWith<$Res> implements $EnergyTokenStackCopyWith<$Res> {
  factory _$EnergyTokenStackCopyWith(_EnergyTokenStack value, $Res Function(_EnergyTokenStack) _then) = __$EnergyTokenStackCopyWithImpl;
@override @useResult
$Res call({
 Position position, int count
});


@override $PositionCopyWith<$Res> get position;

}
/// @nodoc
class __$EnergyTokenStackCopyWithImpl<$Res>
    implements _$EnergyTokenStackCopyWith<$Res> {
  __$EnergyTokenStackCopyWithImpl(this._self, this._then);

  final _EnergyTokenStack _self;
  final $Res Function(_EnergyTokenStack) _then;

/// Create a copy of EnergyTokenStack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? count = null,}) {
  return _then(_EnergyTokenStack(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EnergyTokenStack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

// dart format on
