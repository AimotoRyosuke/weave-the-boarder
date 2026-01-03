import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

part 'border_edge.freezed.dart';
part 'border_edge.g.dart';

enum BorderOrientation { top, right, bottom, left }

extension BorderOrientationX on BorderOrientation {
  int get dRow => switch (this) {
    BorderOrientation.top => -1,
    BorderOrientation.bottom => 1,
    _ => 0,
  };

  int get dCol => switch (this) {
    BorderOrientation.left => -1,
    BorderOrientation.right => 1,
    _ => 0,
  };
}

@freezed
sealed class BorderEdge with _$BorderEdge {
  const BorderEdge._();
  @JsonSerializable(explicitToJson: true)
  const factory BorderEdge({
    required Position anchor,
    required BorderOrientation orientation,
    required PlayerColor owner,
    @Default(false) bool isFortified,
    String? groupId,
  }) = _BorderEdge;
  factory BorderEdge.fromJson(Map<String, dynamic> json) =>
      _$BorderEdgeFromJson(json);
}
