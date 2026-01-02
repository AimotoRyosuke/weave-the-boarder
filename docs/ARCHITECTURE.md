# Weave the Border - アーキテクチャ設計書

## 概要

Flutter + Riverpod + Firebase Realtime Databaseを使用した2人対戦ボードゲーム

## 対戦方式

- **ローカル対戦**: 同一デバイスで2人プレイ
- **オンライン対戦**: ホスト/ゲスト方式
  - ホストが部屋を作成 → 6桁の部屋番号を生成
  - ゲストが部屋番号を入力して入室
  - リアルタイムで盤面を同期

---

## パッケージ構成

### dependencies

| パッケージ            | 役割                                                               |
| --------------------- | ------------------------------------------------------------------ |
| `flutter`             | UI フレームワーク本体（Flutter SDK）。                             |
| `hooks_riverpod`      | Riverpod ベースの状態管理（Hooks 版）。                            |
| `flutter_hooks`       | フック API を Flutter コンポーネントで使うため。                   |
| `riverpod_annotation` | Riverpod/generated 保守用のアノテーション。                        |
| `freezed_annotation`  | イミュータブルモデル定義のコード生成に使用。                       |
| `json_annotation`     | モデルの JSON シリアライズ用アノテーション。                       |
| `firebase_core`       | Firebase 初期化と共通設定。                                        |
| `firebase_database`   | オンライン対戦のリアルタイム同期。                                 |
| `firebase_auth`       | 匿名認証などのユーザ識別。                                         |
| `shared_preferences`  | ローカル設定・状態の永続化。                                       |
| `animations`          | UI アニメーション強化（遷移など）。                                |
| `uuid`                | 一意な文字列（部屋コードやトークン）の生成。                       |
| `cupertino_icons`     | iOS 風アイコンセット。                                             |
| `gap`                 | 縦方向の隙間を簡潔に表現するユーティリティ（`Gap` ウィジェット）。 |

### dev_dependencies

| パッケージ           | 役割                                          |
| -------------------- | --------------------------------------------- |
| `flutter_test`       | Flutter 固有のテストフレームワーク。          |
| `build_runner`       | コード生成タスクの起動ランナー。              |
| `freezed`            | `freezed_annotation` からモデルコードを生成。 |
| `json_serializable`  | JSON シリアライズコード生成。                 |
| `riverpod_generator` | Riverpod プロバイダのコード生成。             |
| `flutter_lints`      | Flutter 標準の lint ルール。                  |
| `riverpod_lint`      | Riverpod 専用の lint ルール設定。             |
| `custom_lint`        | 任意の lint ルールを組み合わせる仕組み。      |

---

## ディレクトリ構成

```text
lib/
├── main.dart
│
├── core/
│   ├── constants/
│   │   ├── game_constants.dart       # ゲーム定数（ボードサイズ、トークン数等）
│   │   ├── firebase_paths.dart       # Firebaseパス定義
│   │   └── app_theme.dart            # アプリテーマ
│   ├── extensions/
│   │   └── position_extension.dart   # Position拡張メソッド
│   └── utils/
│       ├── room_code_generator.dart  # 部屋番号生成
│       └── validators.dart           # バリデーション
│
├── models/
│   ├── game/
│   │   ├── game_state.dart           # ゲーム状態全体
│   │   ├── game_state.freezed.dart
│   │   ├── game_state.g.dart
│   │   ├── board.dart                # 5x5ボード
│   │   ├── cell.dart                 # 個別セル
│   │   ├── player.dart               # プレイヤー
│   │   ├── position.dart             # 座標
│   │   ├── border_edge.dart          # 境界の辺
│   │   └── action_type.dart          # アクション種別
│   │
│   ├── online/
│   │   ├── room.dart                 # オンライン部屋情報
│   │   ├── room.freezed.dart
│   │   ├── room.g.dart
│   │   ├── room_status.dart          # 部屋状態（待機中/進行中/終了）
│   │   └── player_role.dart          # ホスト/ゲスト
│   │
│   └── local/
│       └── game_settings.dart        # ローカル設定
│
├── providers/
│   ├── game/
│   │   ├── game_state_provider.dart           # ゲーム状態管理
│   │   ├── game_state_provider.g.dart
│   │   ├── game_logic_provider.dart           # ゲームロジック
│   │   └── action_validator_provider.dart     # アクション検証
│   │
│   ├── online/
│   │   ├── firebase_provider.dart             # Firebase初期化
│   │   ├── room_provider.dart                 # 部屋管理
│   │   ├── room_provider.g.dart
│   │   ├── room_sync_provider.dart            # リアルタイム同期
│   │   └── connection_provider.dart           # 接続状態監視
│   │
│   └── local/
│       └── settings_provider.dart             # ローカル設定
│
├── services/
│   ├── game/
│   │   ├── game_rule_service.dart             # ルール判定
│   │   ├── score_calculator.dart              # スコア計算
│   │   └── area_detector.dart                 # エリア検出
│   │
│   ├── online/
│   │   ├── firebase_room_service.dart         # Firebase部屋操作
│   │   ├── room_code_service.dart             # 部屋番号管理
│   │   └── sync_service.dart                  # 同期サービス
│   │
│   └── local/
│       └── storage_service.dart               # SharedPreferences操作
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart                   # ホーム画面
│   │   └── widgets/
│   │       ├── mode_selector.dart             # モード選択
│   │       └── title_widget.dart
│   │
│   ├── room/
│   │   ├── create_room_screen.dart            # 部屋作成画面
│   │   ├── join_room_screen.dart              # 部屋参加画面
│   │   ├── waiting_room_screen.dart           # 待機画面
│   │   └── widgets/
│   │       ├── room_code_display.dart         # 部屋番号表示
│   │       └── room_code_input.dart           # 部屋番号入力
│   │
│   ├── game/
│   │   ├── game_screen.dart                   # ゲーム画面
│   │   └── widgets/
│   │       ├── game_board_widget.dart         # ボード全体
│   │       ├── board_cell_widget.dart         # セル
│   │       ├── border_line_widget.dart        # 境界線
│   │       ├── player_piece_widget.dart       # コマ
│   │       ├── energy_panel.dart              # エネルギーパネル
│   │       ├── action_panel.dart              # アクション選択
│   │       ├── turn_indicator.dart            # ターン表示
│   │       └── game_info_panel.dart           # ゲーム情報
│   │
│   └── result/
│       ├── result_screen.dart                 # 結果画面
│       └── widgets/
│           ├── score_breakdown.dart           # スコア詳細
│           └── winner_display.dart            # 勝者表示
│
└── widgets/
    ├── common/
    │   ├── loading_overlay.dart               # ローディング
    │   ├── error_dialog.dart                  # エラーダイアログ
    │   └── custom_button.dart                 # カスタムボタン
    │
    └── animations/
        ├── piece_move_animation.dart          # コマ移動
        └── border_place_animation.dart        # 境界設置
```

---

## データフロー

### ローカル対戦

```text
User Action → GameStateProvider → GameLogicProvider → UI Update
```

### オンライン対戦

```text
[ホスト側]
User Action → GameStateProvider → FirebaseRoomService → Firebase Database

[ゲスト側]
Firebase Database → RoomSyncProvider → GameStateProvider → UI Update
```

---

## Firebase Realtime Database 構造

```json
{
  "rooms": {
    "{roomCode}": {
      "code": "ABC123",
      "status": "waiting | playing | finished",
      "hostId": "user_xxx",
      "guestId": "user_yyy",
      "createdAt": 1234567890,
      "gameState": {
        "board": {
          "cells": [...],
          "borders": [...]
        },
        "players": {
          "white": {...},
          "black": {...}
        },
        "currentTurn": "white | black",
        "energyTokens": [...],
        "turnCount": 0
      }
    }
  }
}
```

---

## 主要機能実装方針

### 1. 部屋作成フロー

1. ホストが「オンライン対戦」→「部屋を作る」を選択
2. `RoomCodeService`で6桁英数字コード生成
3. `FirebaseRoomService`でFirebaseに部屋データ作成
4. 待機画面で部屋番号を表示
5. `RoomSyncProvider`でゲスト参加を監視

### 2. 部屋参加フロー

1. ゲストが「オンライン対戦」→「部屋に入る」を選択
2. 6桁コードを入力
3. `FirebaseRoomService`で部屋の存在確認
4. 部屋が存在し、待機中なら参加
5. ホスト側に通知、ゲーム開始

### 3. ゲーム同期

- ホストがアクション実行 → Firebase更新
- `RoomSyncProvider`が変更を検知 → ゲストの画面更新
- ターン制なので競合は発生しない
- 切断時は`ConnectionProvider`で検知し、再接続処理

### 4. ゲーム終了

- 勝利条件達成時、Firebase上のステータスを`finished`に変更
- 両者に結果画面表示
- 一定時間後、部屋データを自動削除（Cloud Functions or クライアント側）

---

## セキュリティルール（Firebase）

```json
{
  "rules": {
    "rooms": {
      "$roomCode": {
        ".read": true,
        ".write": "!data.exists() || data.child('hostId').val() === auth.uid || data.child('guestId').val() === auth.uid"
      }
    }
  }
}
```

---

## 状態管理パターン（Riverpod）

### NotifierProvider パターン

```dart
@riverpod
class GameController extends _$GameController {
  @override
  GameState build() => GameState.initial();
  
  void executeAction(ActionType action) {
    // ロジック実行
    state = state.copyWith(...);
  }
}
```

### StreamProvider パターン（リアルタイム同期）

```dart
@riverpod
Stream<Room?> roomStream(RoomStreamRef ref, String roomCode) {
  return ref.watch(firebaseServiceProvider).watchRoom(roomCode);
}
```

---

## テスト戦略

- `test/models/`: モデルのシリアライズテスト
- `test/services/game/`: ゲームロジックの単体テスト
- `test/providers/`: プロバイダーの状態変化テスト
- `integration_test/`: オンライン対戦フロー結合テスト

---

## 今後の拡張性

- リプレイ機能（ゲーム履歴保存）
- フレンドリスト機能
- ランキング機能
- AIモード（オフライン対CPU）
- カスタムボードサイズ

---

作成日: 2026-01-02
