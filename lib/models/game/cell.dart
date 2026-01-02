import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

part 'cell.freezed.dart';
part 'cell.g.dart';

@freezed
sealed class Cell with _$Cell {
  const Cell._();
  @JsonSerializable(explicitToJson: true)
  const factory Cell({required Position position, PlayerColor? owner}) = _Cell;

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);

  bool get isControlled => owner != null;
}
