// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Board {

 List<Cell> get cells; List<BorderEdge> get borders; List<EnergyTokenStack> get energyStacks;
/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardCopyWith<Board> get copyWith => _$BoardCopyWithImpl<Board>(this as Board, _$identity);

  /// Serializes this Board to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Board&&const DeepCollectionEquality().equals(other.cells, cells)&&const DeepCollectionEquality().equals(other.borders, borders)&&const DeepCollectionEquality().equals(other.energyStacks, energyStacks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cells),const DeepCollectionEquality().hash(borders),const DeepCollectionEquality().hash(energyStacks));

@override
String toString() {
  return 'Board(cells: $cells, borders: $borders, energyStacks: $energyStacks)';
}


}

/// @nodoc
abstract mixin class $BoardCopyWith<$Res>  {
  factory $BoardCopyWith(Board value, $Res Function(Board) _then) = _$BoardCopyWithImpl;
@useResult
$Res call({
 List<Cell> cells, List<BorderEdge> borders, List<EnergyTokenStack> energyStacks
});




}
/// @nodoc
class _$BoardCopyWithImpl<$Res>
    implements $BoardCopyWith<$Res> {
  _$BoardCopyWithImpl(this._self, this._then);

  final Board _self;
  final $Res Function(Board) _then;

/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cells = null,Object? borders = null,Object? energyStacks = null,}) {
  return _then(_self.copyWith(
cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,borders: null == borders ? _self.borders : borders // ignore: cast_nullable_to_non_nullable
as List<BorderEdge>,energyStacks: null == energyStacks ? _self.energyStacks : energyStacks // ignore: cast_nullable_to_non_nullable
as List<EnergyTokenStack>,
  ));
}

}


/// Adds pattern-matching-related methods to [Board].
extension BoardPatterns on Board {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Board value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Board() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Board value)  $default,){
final _that = this;
switch (_that) {
case _Board():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Board value)?  $default,){
final _that = this;
switch (_that) {
case _Board() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Cell> cells,  List<BorderEdge> borders,  List<EnergyTokenStack> energyStacks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Board() when $default != null:
return $default(_that.cells,_that.borders,_that.energyStacks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Cell> cells,  List<BorderEdge> borders,  List<EnergyTokenStack> energyStacks)  $default,) {final _that = this;
switch (_that) {
case _Board():
return $default(_that.cells,_that.borders,_that.energyStacks);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Cell> cells,  List<BorderEdge> borders,  List<EnergyTokenStack> energyStacks)?  $default,) {final _that = this;
switch (_that) {
case _Board() when $default != null:
return $default(_that.cells,_that.borders,_that.energyStacks);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Board extends Board {
  const _Board({required final  List<Cell> cells, final  List<BorderEdge> borders = const [], required final  List<EnergyTokenStack> energyStacks}): _cells = cells,_borders = borders,_energyStacks = energyStacks,super._();
  factory _Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

 final  List<Cell> _cells;
@override List<Cell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

 final  List<BorderEdge> _borders;
@override@JsonKey() List<BorderEdge> get borders {
  if (_borders is EqualUnmodifiableListView) return _borders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_borders);
}

 final  List<EnergyTokenStack> _energyStacks;
@override List<EnergyTokenStack> get energyStacks {
  if (_energyStacks is EqualUnmodifiableListView) return _energyStacks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_energyStacks);
}


/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardCopyWith<_Board> get copyWith => __$BoardCopyWithImpl<_Board>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Board&&const DeepCollectionEquality().equals(other._cells, _cells)&&const DeepCollectionEquality().equals(other._borders, _borders)&&const DeepCollectionEquality().equals(other._energyStacks, _energyStacks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells),const DeepCollectionEquality().hash(_borders),const DeepCollectionEquality().hash(_energyStacks));

@override
String toString() {
  return 'Board(cells: $cells, borders: $borders, energyStacks: $energyStacks)';
}


}

/// @nodoc
abstract mixin class _$BoardCopyWith<$Res> implements $BoardCopyWith<$Res> {
  factory _$BoardCopyWith(_Board value, $Res Function(_Board) _then) = __$BoardCopyWithImpl;
@override @useResult
$Res call({
 List<Cell> cells, List<BorderEdge> borders, List<EnergyTokenStack> energyStacks
});




}
/// @nodoc
class __$BoardCopyWithImpl<$Res>
    implements _$BoardCopyWith<$Res> {
  __$BoardCopyWithImpl(this._self, this._then);

  final _Board _self;
  final $Res Function(_Board) _then;

/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cells = null,Object? borders = null,Object? energyStacks = null,}) {
  return _then(_Board(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<Cell>,borders: null == borders ? _self._borders : borders // ignore: cast_nullable_to_non_nullable
as List<BorderEdge>,energyStacks: null == energyStacks ? _self._energyStacks : energyStacks // ignore: cast_nullable_to_non_nullable
as List<EnergyTokenStack>,
  ));
}


}

// dart format on
