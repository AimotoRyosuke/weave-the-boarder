import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/models/game/position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'action_provider.g.dart';

class ActionState {
  const ActionState({
    this.type = ActionType.move,

    this.selectedEdges = const [],

    this.pendingEdges = const [],

    this.pendingPosition,
  });

  final ActionType type;

  final List<BorderEdge> selectedEdges;

  final List<BorderEdge> pendingEdges;

  final Position? pendingPosition;

  ActionState copyWith({
    ActionType? type,

    List<BorderEdge>? selectedEdges,

    List<BorderEdge>? pendingEdges,

    Position? pendingPosition,
  }) {
    return ActionState(
      type: type ?? this.type,

      selectedEdges: selectedEdges ?? this.selectedEdges,

      pendingEdges: pendingEdges ?? this.pendingEdges,

      pendingPosition: pendingPosition ?? this.pendingPosition,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionState &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _listEquals(selectedEdges, other.selectedEdges) &&
          _listEquals(pendingEdges, other.pendingEdges) &&
          pendingPosition == other.pendingPosition;

  @override
  int get hashCode =>
      type.hashCode ^
      selectedEdges.hashCode ^
      pendingEdges.hashCode ^
      pendingPosition.hashCode;

  bool _listEquals(List<BorderEdge> a, List<BorderEdge> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}

@riverpod
class Action extends _$Action {
  @override
  ActionState build() => const ActionState();

  void select(ActionType type) {
    if (state.type == type) {
      state = const ActionState(type: ActionType.move);
    } else {
      state = ActionState(type: type);
    }
  }

  void selectEdges(List<BorderEdge> edges) {
    state = state.copyWith(selectedEdges: edges);
  }

  void setPendingEdges(List<BorderEdge> edges) {
    state = state.copyWith(pendingEdges: edges);
  }

  void setPendingPosition(Position? position) {
    state = state.copyWith(pendingPosition: position);
  }

  void reset() => state = const ActionState(type: ActionType.move);
}
