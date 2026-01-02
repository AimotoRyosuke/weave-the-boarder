import 'package:flutter_test/flutter_test.dart';
import 'package:weave_the_border/core/constants/game_constants.dart';
import 'package:weave_the_border/models/game/action_type.dart';
import 'package:weave_the_border/models/game/border_edge.dart';
import 'package:weave_the_border/models/game/board.dart';
import 'package:weave_the_border/models/game/cell.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';
import 'package:weave_the_border/models/game/player.dart';
import 'package:weave_the_border/models/game/player_color.dart';
import 'package:weave_the_border/models/game/position.dart';

void main() {
  group('Position', () {
    test('ボード上にあるかを判定できる', () {
      final inside = Position(row: 2, col: 3);
      final corner = Position(row: GameConstants.boardSize - 1, col: 0);
      final outside = Position(row: -1, col: GameConstants.boardSize);

      expect(inside.isOnBoard, isTrue);
      expect(corner.isOnBoard, isTrue);
      expect(outside.isOnBoard, isFalse);
      expect(inside.key, '2,3');
      expect(inside.offset(-2, 1), equals(Position(row: 0, col: 4)));
    });

    test('JSON 変換に対応している', () {
      final position = Position(row: 4, col: 1);
      final restored = Position.fromJson(position.toJson());
      expect(restored, equals(position));
    });
  });

  group('Player', () {
    test('所持情報と JSON 変換', () {
      final player = Player(
        color: PlayerColor.white,
        piecePosition: Position(row: 0, col: 0),
      );
      final restored = Player.fromJson(player.toJson());

      expect(player.isOnBoard, isTrue);
      expect(player.remainingBorders, GameConstants.borderTokensPerPlayer);
      expect(restored, equals(player));
    });
  });

  group('Cell', () {
    test('所有者の有無によって制御されているか判定', () {
      final controlled = Cell(
        position: Position(row: 1, col: 1),
        owner: PlayerColor.black,
      );
      final neutral = Cell(position: Position(row: 1, col: 2));

      expect(controlled.isControlled, isTrue);
      expect(neutral.isControlled, isFalse);
      expect(Cell.fromJson(controlled.toJson()), equals(controlled));
    });
  });

  group('BorderEdge', () {
    test('方向ベクトルを返す', () {
      expect(BorderOrientation.top.dRow, -1);
      expect(BorderOrientation.top.dCol, 0);
      expect(BorderOrientation.bottom.dRow, 1);
      expect(BorderOrientation.bottom.dCol, 0);
      expect(BorderOrientation.left.dRow, 0);
      expect(BorderOrientation.left.dCol, -1);
      expect(BorderOrientation.right.dRow, 0);
      expect(BorderOrientation.right.dCol, 1);
    });

    test('JSON 変換に対応している', () {
      final edge = BorderEdge(
        anchor: Position(row: 2, col: 2),
        orientation: BorderOrientation.right,
        owner: PlayerColor.white,
        isFortified: true,
      );
      expect(BorderEdge.fromJson(edge.toJson()), equals(edge));
    });
  });

  group('EnergyTokenStack', () {
    test('トークンの有無と隣接判定', () {
      final center = Position(row: 2, col: 2);
      final stack = EnergyTokenStack(position: center, count: 2);
      final empty = EnergyTokenStack(position: center);

      expect(stack.hasTokens, isTrue);
      expect(stack.tokensAdjacent(center), 2);
      expect(stack.tokensAdjacent(Position(row: 0, col: 0)), 0);
      expect(empty.hasTokens, isFalse);
    });

    test('JSON 変換に対応している', () {
      final stack = EnergyTokenStack(
        position: Position(row: 3, col: 1),
        count: 1,
      );
      expect(EnergyTokenStack.fromJson(stack.toJson()), equals(stack));
    });
  });

  group('Board', () {
    test('初期状態のボードを構築できる', () {
      final board = Board.initial();
      final center = Position(
        row: GameConstants.boardSize ~/ 2,
        col: GameConstants.boardSize ~/ 2,
      );

      expect(
        board.cells,
        hasLength(GameConstants.boardSize * GameConstants.boardSize),
      );
      expect(board.energyStacks, hasLength(1));
      expect(board.hasEnergyAt(center), isTrue);
      expect(
        board.cellAt(Position(row: 0, col: 0)).owner,
        equals(PlayerColor.white),
      );
      expect(
        board
            .cellAt(
              Position(
                row: GameConstants.boardSize - 1,
                col: GameConstants.boardSize - 1,
              ),
            )
            .owner,
        equals(PlayerColor.black),
      );
    });

    test('セルやスタックの取得と例外処理', () {
      final board = Board.initial();
      final missingPosition = Position(row: -1, col: 0);
      final emptyPosition = Position(row: 0, col: 1);

      expect(() => board.cellAt(missingPosition), throwsRangeError);
      expect(board.stackAt(emptyPosition).count, 0);
      expect(board.hasEnergyAt(emptyPosition), isFalse);
    });
  });

  group('ActionType', () {
    test('説明が固定値と一致', () {
      final expectedDescriptions = {
        ActionType.move: '駒を移動',
        ActionType.placeBorder: '境界設置',
        ActionType.collectEnergy: 'エネルギー収集',
        ActionType.specialMove: '追加移動',
        ActionType.specialBreakBorder: '境界破壊',
        ActionType.specialFortify: '要塞化',
        ActionType.pass: 'パス',
      };

      for (final entry in expectedDescriptions.entries) {
        expect(entry.key.description, equals(entry.value));
      }
    });
  });
}
