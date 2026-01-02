enum PlayerColor {
  white,
  black;

  String get displayName => switch (this) {
    PlayerColor.white => '白',
    PlayerColor.black => '黒',
  };

  PlayerColor get opponent => switch (this) {
    PlayerColor.white => PlayerColor.black,
    PlayerColor.black => PlayerColor.white,
  };
}
