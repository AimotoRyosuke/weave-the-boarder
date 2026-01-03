import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:weave_the_border/services/game/border_helper.dart';

class AreaDetector {
  const AreaDetector();

  List<Set<Position>> detectConnectedAreas(Board board, PlayerColor color) {
    final cellsByKey = {
      for (final cell in board.cells) cell.position.key: cell,
    };
    final visited = <String>{};
    final areas = <Set<Position>>[];

    for (final cell in board.cells) {
      if (cell.owner != color) {
        continue;
      }
      if (visited.contains(cell.position.key)) {
        continue;
      }

      final queue = <Position>[cell.position];
      final currentArea = <Position>{};
      visited.add(cell.position.key);

      while (queue.isNotEmpty) {
        final current = queue.removeLast();
        currentArea.add(current);

        for (final neighbor in BorderHelper.orthogonalNeighbors(current)) {
          if (!neighbor.isOnBoard) {
            continue;
          }
          final neighborCell = cellsByKey[neighbor.key];
          if (neighborCell == null || neighborCell.owner != color) {
            continue;
          }
          if (BorderHelper.hasBorderBetween(current, neighbor, board.borders)) {
            continue;
          }
          if (visited.add(neighbor.key)) {
            queue.add(neighbor);
          }
        }
      }

      areas.add(currentArea);
    }

    return areas;
  }

  bool isFullyEnclosed(Board board, Set<Position> area) {
    for (final cell in area) {
      for (final neighbor in BorderHelper.orthogonalNeighbors(cell)) {
        if (!neighbor.isOnBoard) {
          continue; // board edge counts as closed
        }
        if (area.contains(neighbor)) {
          continue;
        }
        if (!BorderHelper.hasBorderBetween(cell, neighbor, board.borders)) {
          return false;
        }
      }
    }

    return true;
  }

  Set<BorderEdge> perimeterBorders(Board board, Set<Position> area) {
    final perimeter = <BorderEdge>{};
    for (final cell in area) {
      for (final neighbor in BorderHelper.orthogonalNeighbors(cell)) {
        if (!neighbor.isOnBoard) {
          continue;
        }
        if (area.contains(neighbor)) {
          continue;
        }
        final edge = BorderHelper.findEdgeBetween(
          cell,
          neighbor,
          board.borders,
        );
        if (edge != null) {
          perimeter.add(edge);
        }
      }
    }
    return perimeter;
  }
}
