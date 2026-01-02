enum ActionType {
  move,
  placeBorder,
  collectEnergy,
  specialMove,
  specialBreakBorder,
  specialFortify,
  pass;

  String get description => switch (this) {
    move => '駒を移動',
    placeBorder => '境界設置',
    collectEnergy => 'エネルギー収集',
    specialMove => '追加移動',
    specialBreakBorder => '境界破壊',
    specialFortify => '要塞化',
    pass => 'パス',
  };
}
