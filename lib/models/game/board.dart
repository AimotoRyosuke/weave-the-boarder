import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

part 'board.freezed.dart';
part 'board.g.dart';

@freezed
sealed class Board with _$Board {
  const Board._();
  @JsonSerializable(explicitToJson: true)
  const factory Board({
    required List<Cell> cells,
    @Default([]) List<BorderEdge> borders,
    required List<EnergyTokenStack> energyStacks,
  }) = _Board;

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  static Board initial() {
    final cells = <Cell>[];
    final size = GameConstants.boardSize;
    for (var row = 0; row < size; row++) {
      for (var col = 0; col < size; col++) {
        PlayerColor? owner;
        if (row == 0 && col == 0) {
          owner = PlayerColor.white;
        } else if (row == size - 1 && col == size - 1) {
          owner = PlayerColor.black;
        }
        cells.add(
          Cell(
            position: Position(row: row, col: col),
            owner: owner,
          ),
        );
      }
    }

    final centerIndex = size ~/ 2;
    final energyStacks = [
      EnergyTokenStack(
        position: Position(row: centerIndex, col: centerIndex),
        count: GameConstants.initialCenterEnergy,
      ),
    ];

    return Board(cells: cells, energyStacks: energyStacks);
  }

  Cell cellAt(Position position) => cells.firstWhere(
    (cell) => cell.position == position,
    orElse: () => throw RangeError('Invalid position: $position'),
  );

  EnergyTokenStack stackAt(Position position) {
    return energyStacks.firstWhere(
      (stack) => stack.position == position,
      orElse: () => EnergyTokenStack(position: position),
    );
  }

  bool hasEnergyAt(Position position) => stackAt(position).hasTokens;

  Position positionFromIndex(int index) {
    final size = GameConstants.boardSize;
    if (index < 0 || index >= size * size) {
      throw RangeError('Invalid index: $index');
    }
    return Position(row: index ~/ size, col: index % size);
  }
}
