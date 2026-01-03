import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/position.dart';

class BorderHelper {
  const BorderHelper._();

  static const _directions = BorderOrientation.values;

  static Position getNeighbor(Position anchor, BorderOrientation orientation) =>
      anchor.offset(orientation.dRow, orientation.dCol);

  static BorderOrientation? orientationBetween(
    Position source,
    Position target,
  ) {
    final dRow = target.row - source.row;
    final dCol = target.col - source.col;
    return switch (dRow) {
      -1 when dCol == 0 => BorderOrientation.top,
      1 when dCol == 0 => BorderOrientation.bottom,
      _ => switch (dCol) {
        -1 when dRow == 0 => BorderOrientation.left,
        1 when dRow == 0 => BorderOrientation.right,
        _ => null,
      },
    };
  }

  static BorderEdge? findEdgeBetween(
    Position a,
    Position b,
    List<BorderEdge> edges,
  ) {
    for (final edge in edges) {
      final neighbor = getNeighbor(edge.anchor, edge.orientation);
      if (edge.anchor == a && neighbor == b) {
        return edge;
      }
      if (edge.anchor == b && neighbor == a) {
        return edge;
      }
    }
    return null;
  }

  static bool hasBorderBetween(
    Position a,
    Position b,
    List<BorderEdge> edges,
  ) => findEdgeBetween(a, b, edges) != null;

  static BorderEdge? findByAnchor(
    Position anchor,
    BorderOrientation orientation,
    List<BorderEdge> edges,
  ) {
    for (final edge in edges) {
      if (edge.anchor == anchor && edge.orientation == orientation) {
        return edge;
      }
    }
    return null;
  }

  static Iterable<Position> orthogonalNeighbors(Position position) sync* {
    for (final orientation in _directions) {
      yield getNeighbor(position, orientation);
    }
  }
}
