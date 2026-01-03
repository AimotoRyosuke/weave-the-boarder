# 塗り潰せ - アーキテクチャ設計書

## 概要

Flutter + Riverpod + Firebase Realtime Databaseを使用した、7×7盤面の2人対戦陣取りボードゲーム。

## ゲームルール（サマリー）

- **勝利条件**: 先に15マスを自分の色で塗り潰したプレイヤーの勝利。
- **ターン**: 1ターン1アクション制。アクション完了後、自動で手番が交代。
- **アクション**: 移動（通常/2マス）、壁の設置（1マス/2マス）、壁の再配置。
- **エナジー**: 盤面上のエナジーマスに止まることで獲得。特殊アクションの消費に使用。

---

## パッケージ構成

### dependencies

| パッケージ           | 役割                                                   |
| -------------------- | ------------------------------------------------------ |
| `hooks_riverpod`     | 状態管理の核。NotifierProviderによるゲーム状態の管理。 |
| `freezed_annotation` | イミュータブルなGameState、Player、Boardモデルの定義。 |
| `firebase_database`  | オンライン対戦におけるGameStateのリアルタイム同期。    |
| `firebase_auth`      | 匿名認証によるプレイヤー識別。                         |

---

## ディレクトリ構成

```text
lib/
├── core/
│   ├── constants/
│   │   ├── game_constants.dart       # ボードサイズ(7)、勝利数(15)、初期エナジー等
│   │   └── app_theme.dart            # パステルカラーを基調としたチームカラー
│   └── exceptions/
│       └── invalid_action_exception.dart # ルール違反時の例外
│
├── models/
│   ├── game/
│   │   ├── game_state.dart           # actionsRemaining, currentTurn等を含む全体状態
│   │   ├── board.dart                # 7x7セルの管理、エナジー配置ロジック
│   │   ├── cell.dart                 # 所有者（PlayerColor）の情報
│   │   ├── player.dart               # 座標、残り壁数、所持エナジー
│   │   ├── player_color.dart         # blue(青) / red(赤) の定義とパステルカラー値
│   │   ├── border_edge.dart          # 壁の定義。groupIdによる2マス壁の連結管理
│   │   ├── position.dart             # 座標(row, col)。無効値(none)の定義
│   │   └── action_type.dart          # 移動、壁設置、再配置等の列挙型
│   └── ...
│
├── providers/
│   ├── game/
│   │   ├── game_controller_provider.dart  # ゲームの主状態（GameState）を管理
│   │   ├── action_provider.dart           # UI上の操作状態（選択中の壁、ドラッグ中のプレビュー等）
│   │   └── action_validator_provider.dart # 操作がルール上有効かの検証
│   └── ...
│
├── services/
│   ├── game/
│   │   ├── game_rule_service.dart         # 移動・壁設置・再配置の根幹ロジック
│   │   ├── area_detector.dart             # 連結エリア検出、分断禁止チェック(BFS)
│   │   └── score_calculator.dart          # 獲得マス数の集計、勝利判定
│   └── ...
│
├── screens/
│   └── game/
│       ├── game_screen.dart               # 勝利判定・リザルト表示・全体レイアウト
│       └── widgets/
│           ├── game_board_widget.dart     # ジェスチャー（タップ・ドラッグ）のハンドル
│           ├── board_cell_widget.dart     # セルの描画
│           ├── borders_painter.dart       # 壁（CustomPaint）および「×」印の描画
│           ├── action_selector.dart       # アクション切り替え（移動/1マス壁/2マス壁...）
│           ├── player_status_widget.dart  # スコア、エナジー、残り壁数の表示
│           └── turn_indicator.dart        # 現在の手番表示
└── ...
```

---

## 重要アルゴリズムとデータフロー

### 1. 壁の配置と分断禁止ルール

- `AreaDetector.allCellsConnected` メソッドにて、壁を置いた後の仮想盤面に対してBFS（幅優先探索）を実行。
- いずれかのマスへの到達可能性が失われる（全49マスが繋がらなくなる）配置は、UI上で「×」を表示し、実行をブロックする。

### 2. 操作感（Aim & Release / Drag-to-Place）

- **移動**: `onTapDown`でターゲットを予約（pending）、`onTapUp`または`onPanEnd`で実行。スライドして無効なマスに指を動かすとキャンセル（Position.noneセット）。
- **壁**: `onPanUpdate`でなぞっている辺をリアルタイムに計算し、白いグロー効果でプレビューを表示。

### 3. 自動ターン切り替えと同期

- `GameController` 内のアクションメソッド実行後、`actionsRemaining` が0になったタイミングで `endTurn()` を自動実行。
- オンライン対戦時は、このタイミングでFirebaseのデータが更新され、相手側へ変更が伝播する。

---

## Firebase Realtime Database 構造

```json
{
  "rooms": {
    "{roomCode}": {
      "status": "playing",
      "gameState": {
        "board": {
          "cells": [{ "position": {"row":0, "col":3}, "owner": "red" }, ...],
          "borders": [{ "anchor": {"row":1, "col":1}, "orientation": "top", "groupId": "unique_id" }]
        },
        "players": [
          { "color": "blue", "piecePosition": {"row":6, "col":3}, "energy": 0, "shortWalls": 5, "longWalls": 5 },
          { "color": "red", "piecePosition": {"row":0, "col":3}, "energy": 0, "shortWalls": 5, "longWalls": 5 }
        ],
        "currentTurn": "blue",
        "actionsRemaining": 1
      }
    }
  }
}
```

---

## テスト戦略

- **GameRuleService**: 移動可能範囲、エナジー獲得、壁設置のバリデーション。
- **AreaDetector**: BFSによるボード連結性チェックの正確性。
- **ScoreCalculator**: 15マス到達時の勝利判定。

作成日: 2026-01-03（ルール改訂版）
