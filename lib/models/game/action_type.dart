enum ActionType {
  move,
  placeBorder,
  collectEnergy,
  specialMove,
  specialBreakBorder,
  specialFortify,
  pass;

  String get description => switch (this) {
    ActionType.move => '駒を移動',
    ActionType.placeBorder => '境界設置',
    ActionType.collectEnergy => 'エネルギー収集',
    ActionType.specialMove => '追加移動',
    ActionType.specialBreakBorder => '境界破壊',
    ActionType.specialFortify => '要塞化',
    ActionType.pass => 'パス',
  };
}
