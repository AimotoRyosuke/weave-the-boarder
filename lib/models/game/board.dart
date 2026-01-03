import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'dart:math' as math;

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

  static Board initial({int? seed}) {
    final cells = <Cell>[];
    final size = GameConstants.boardSize;

    const blueStart = Position(row: 6, col: 3);
    const redStart = Position(row: 0, col: 3);

    for (var row = 0; row < size; row++) {
      for (var col = 0; col < size; col++) {
        final pos = Position(row: row, col: col);
        PlayerColor? owner;
        if (pos == blueStart) {
          owner = PlayerColor.blue;
        } else if (pos == redStart) {
          owner = PlayerColor.red;
        }
        cells.add(Cell(position: pos, owner: owner));
      }
    }

    // Energy placement: 1 in row 4, 2 in row 3, 2 in row 2 (relative to blue at row 6)
    final random = math.Random(seed);
    final energyPositions = <Position>[];

    // Row 4: 1 token
    final cols4 = List.generate(size, (i) => i)..shuffle(random);
    energyPositions.add(Position(row: 4, col: cols4.first));

    // Row 3: 2 tokens
    final cols3 = List.generate(size, (i) => i)..shuffle(random);
    energyPositions.add(Position(row: 3, col: cols3[0]));
    energyPositions.add(Position(row: 3, col: cols3[1]));

    // Row 2: 2 tokens
    final cols2 = List.generate(size, (i) => i)..shuffle(random);
    energyPositions.add(Position(row: 2, col: cols2[0]));
    energyPositions.add(Position(row: 2, col: cols2[1]));

    final energyStacks = energyPositions
        .map((pos) => EnergyTokenStack(position: pos, count: 1))
        .toList();

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
