// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'border_edge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BorderEdge {

 Position get anchor; BorderOrientation get orientation; PlayerColor get owner; bool get isFortified; String? get groupId;
/// Create a copy of BorderEdge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorderEdgeCopyWith<BorderEdge> get copyWith => _$BorderEdgeCopyWithImpl<BorderEdge>(this as BorderEdge, _$identity);

  /// Serializes this BorderEdge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorderEdge&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.isFortified, isFortified) || other.isFortified == isFortified)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anchor,orientation,owner,isFortified,groupId);

@override
String toString() {
  return 'BorderEdge(anchor: $anchor, orientation: $orientation, owner: $owner, isFortified: $isFortified, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $BorderEdgeCopyWith<$Res>  {
  factory $BorderEdgeCopyWith(BorderEdge value, $Res Function(BorderEdge) _then) = _$BorderEdgeCopyWithImpl;
@useResult
$Res call({
 Position anchor, BorderOrientation orientation, PlayerColor owner, bool isFortified, String? groupId
});


$PositionCopyWith<$Res> get anchor;

}
/// @nodoc
class _$BorderEdgeCopyWithImpl<$Res>
    implements $BorderEdgeCopyWith<$Res> {
  _$BorderEdgeCopyWithImpl(this._self, this._then);

  final BorderEdge _self;
  final $Res Function(BorderEdge) _then;

/// Create a copy of BorderEdge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anchor = null,Object? orientation = null,Object? owner = null,Object? isFortified = null,Object? groupId = freezed,}) {
  return _then(_self.copyWith(
anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Position,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as BorderOrientation,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as PlayerColor,isFortified: null == isFortified ? _self.isFortified : isFortified // ignore: cast_nullable_to_non_nullable
as bool,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BorderEdge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get anchor {
  
  return $PositionCopyWith<$Res>(_self.anchor, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}


/// Adds pattern-matching-related methods to [BorderEdge].
extension BorderEdgePatterns on BorderEdge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorderEdge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorderEdge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorderEdge value)  $default,){
final _that = this;
switch (_that) {
case _BorderEdge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorderEdge value)?  $default,){
final _that = this;
switch (_that) {
case _BorderEdge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Position anchor,  BorderOrientation orientation,  PlayerColor owner,  bool isFortified,  String? groupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorderEdge() when $default != null:
return $default(_that.anchor,_that.orientation,_that.owner,_that.isFortified,_that.groupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Position anchor,  BorderOrientation orientation,  PlayerColor owner,  bool isFortified,  String? groupId)  $default,) {final _that = this;
switch (_that) {
case _BorderEdge():
return $default(_that.anchor,_that.orientation,_that.owner,_that.isFortified,_that.groupId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Position anchor,  BorderOrientation orientation,  PlayerColor owner,  bool isFortified,  String? groupId)?  $default,) {final _that = this;
switch (_that) {
case _BorderEdge() when $default != null:
return $default(_that.anchor,_that.orientation,_that.owner,_that.isFortified,_that.groupId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BorderEdge extends BorderEdge {
  const _BorderEdge({required this.anchor, required this.orientation, required this.owner, this.isFortified = false, this.groupId}): super._();
  factory _BorderEdge.fromJson(Map<String, dynamic> json) => _$BorderEdgeFromJson(json);

@override final  Position anchor;
@override final  BorderOrientation orientation;
@override final  PlayerColor owner;
@override@JsonKey() final  bool isFortified;
@override final  String? groupId;

/// Create a copy of BorderEdge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorderEdgeCopyWith<_BorderEdge> get copyWith => __$BorderEdgeCopyWithImpl<_BorderEdge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorderEdgeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorderEdge&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.isFortified, isFortified) || other.isFortified == isFortified)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anchor,orientation,owner,isFortified,groupId);

@override
String toString() {
  return 'BorderEdge(anchor: $anchor, orientation: $orientation, owner: $owner, isFortified: $isFortified, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class _$BorderEdgeCopyWith<$Res> implements $BorderEdgeCopyWith<$Res> {
  factory _$BorderEdgeCopyWith(_BorderEdge value, $Res Function(_BorderEdge) _then) = __$BorderEdgeCopyWithImpl;
@override @useResult
$Res call({
 Position anchor, BorderOrientation orientation, PlayerColor owner, bool isFortified, String? groupId
});


@override $PositionCopyWith<$Res> get anchor;

}
/// @nodoc
class __$BorderEdgeCopyWithImpl<$Res>
    implements _$BorderEdgeCopyWith<$Res> {
  __$BorderEdgeCopyWithImpl(this._self, this._then);

  final _BorderEdge _self;
  final $Res Function(_BorderEdge) _then;

/// Create a copy of BorderEdge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anchor = null,Object? orientation = null,Object? owner = null,Object? isFortified = null,Object? groupId = freezed,}) {
  return _then(_BorderEdge(
anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Position,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as BorderOrientation,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as PlayerColor,isFortified: null == isFortified ? _self.isFortified : isFortified // ignore: cast_nullable_to_non_nullable
as bool,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BorderEdge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get anchor {
  
  return $PositionCopyWith<$Res>(_self.anchor, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}

// dart format on
