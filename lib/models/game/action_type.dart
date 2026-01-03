enum ActionType {
  move,
  doubleMove,
  relocateWall,
  placeShortWall,
  placeLongWall,
}

extension ActionTypeX on ActionType {
  bool get consumesEnergy => switch (this) {
    ActionType.doubleMove || ActionType.relocateWall => true,
    _ => false,
  };

  int get energyCost => consumesEnergy ? 1 : 0;
}
