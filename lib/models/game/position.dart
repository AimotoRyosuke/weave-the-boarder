import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';

part 'position.freezed.dart';
part 'position.g.dart';

@freezed
sealed class Position with _$Position {
  const Position._();
  const factory Position({required int row, required int col}) = _Position;

  static const none = Position(row: -1, col: -1);
  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  static int get minIndex => 0;
  static int get maxIndex => GameConstants.boardSize - 1;

  bool get isOnBoard =>
      row >= minIndex && row <= maxIndex && col >= minIndex && col <= maxIndex;

  String get key => '$row,$col';

  Position offset(int dRow, int dCol) =>
      Position(row: row + dRow, col: col + dCol);
}
