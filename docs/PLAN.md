# 開発計画

## 目的
`Weave the Border` のアーキテクチャ・ルールに従いながら、ローカル/オンライン両対戦モードを持つ2人用ボードゲームを段階的に実装する。

## フェーズ構成
各フェーズは最大 1～2 週間想定。短いスプリントで実装と検証を交互に回す。

1. **ゲームルールの作成**（完了）
   - `RULE.md` を基に勝利条件・ターン進行・特殊アクション・得点計算の要件を明文化し、今後の実装にブレが出ないよう確定済み。
   - 必要であれば UI やサービスレイヤでルールを再確認するための参照資料として活用。

2. **アーキテクチャ検討**（完了）
   - `docs/ARCHITECTURE.md` でディレクトリ構成・プロバイダ構成・Firebase データフローを整理し、各責務を明確化。
   - パッケージ構成と役割をドキュメント化し、実装フェーズに入る前にインフラ構成の認識を揃えた状態。

3. **開発計画の作成**（完了）
   - 本 `PLAN.md` により、依存関係・モデル・UI・同期・テストのフェーズとチェックポイントを整理。
   - 進行管理チェックリストで各フェーズの完了条件を追跡できるようにしている。

4. **依存関係と環境整備**
   - `pubspec.yaml` に記載されているパッケージを `flutter pub get` で解決し、`flutter analyze` で `analysis_options.yaml`/`custom_lint` に沿うよう確認。
   - `build_runner` を使って `.freezed.dart`/`.g.dart` が生成される仕組みを確認し、ビルド環境を安定させる。必要に応じて `.gitignore` や `build.yaml` を整理。
   - Firebase 初期化のスケルトン（`firebase_provider` や `core/constants` の定数）を置き、`.plist`/`json` の配置方法とセキュリティルールの定義方法をチームに共有。

5. **データモデル構築**
   - `models/game` で Freezed/JSON モデル（`GameStateModel`, `Board`, `Cell`, `Player`, `BorderEdge`, `ActionType`）を定義し、シリアライズ形式を明示。
   - `models/online/room` など Firebase 用モデルも同様に整備し、`freezed` で `.freezed.dart`/`.g.dart` を生成するルーチンを確立。
   - モデルに対するユニットテスト（`test/models/`）を用意し、シリアライズ/バリデーションが破綻していないことを確認。

6. **ゲームロジック実装**
   - `services/game` にルール判定・エリア検出・スコア計算を集約し、`RULE.md` の勝利条件や特殊アクションをコード化。
   - `providers/game/game_state_provider.dart` などで State/StateNotifier を組み立て、基本アクション（移動・境界設置・エネルギー取得）/特殊アクションの処理を `GameState` に反映。
   - `test/services/game/` でロジック単体テストを行い、ターンルールやエネルギー補充などを証明。

7. **ローカル UI フロー**
   - `screens/home/`、`widgets/common` でモード選択・タイトル・ローディングを整え、ローカルプレイへの橋渡しを作る。
   - `screens/game/` のウィジェット群でボード/セル/境界/コマ/パネルを構成し、`GameState` と Riverpod を接続したインタラクティブな UI を実装。即時確認用に `widget_test` を用意。
   - `screens/room/` で部屋遷移を仮実装し、ローカル対戦モードで画面遷移が成立することを確認。

8. **オンライン同期連携**
   - `services/online` に Firebase 書き込み・同期ロジックを実装し、部屋データ/状態遷移・同期用メソッドを整備（`FirebaseRoomService`, `SyncService`）。
   - `providers/online` で `room_provider`, `room_sync_provider`, `connection_provider` を整え、ホスト/ゲストの役割に応じたデータフローを設計。
   - Firebase セキュリティルールを確定し、ローカル環境でホスト/ゲスト両方を起動して同期の安定性を確認。

9. **テスト & QA**
   - `test/providers/`/`integration_test/` で状態遷移・オンラインフローを検証し、`flutter test` を通す。
   - `flutter analyze` + lint（`flutter_lints`, `riverpod_lint`, `custom_lint`）を走らせ、CI 相当の品質ガードを確立。
   - ドキュメント（`docs/ARCHITECTURE.md`, `RULE.md`, `PLAN.md`）をアップデートし、実装状況とのズレを補正。

## 追加作業の優先度
- Firebase 設定・認証まわりはオンライン対戦の根幹なので、モデル実装より先に済ませる。
- UI はローカルモードで動作確認できる段階で進め、後からオンライン同期をつなげる。
- `build_runner` で生成される `.g.dart`/`.freezed.dart` を `git` に含めるかをチームで決めておき、差分管理を楽にする。

## 進行確認のタイミング
- 各フェーズの節目で `flutter test` + `flutter analyze` を実行し、主要なバグ・lint違反がないかを確認。
- Firebase の同期処理を追加したら、ホスト/ゲスト両方の挙動を実機/エミュレータで確認し、切断や再接続も想定したテストを行う。
- 開発途中にルール変更があれば `RULE.md`/`ARCHITECTURE.md` を忘れず更新して記録。

## 進行管理チェックリスト
- [x] フェーズ1（ゲームルールの作成）：`RULE.md` を確定し、ルールベースを文書化
- [x] フェーズ2（アーキテクチャ検討）：`docs/ARCHITECTURE.md` を元にディレクトリ/データフローを整理
- [x] フェーズ3（開発計画の作成）：この `PLAN.md` により段階とチェックポイントを確立
- [ ] フェーズ4（依存関係と環境整備）：`flutter pub get`・`flutter analyze` を通し、Firebase 初期化スケルトンを配置
- [ ] フェーズ5（データモデル構築）：Freezed/JSON モデル生成 + `test/models/` でシリアライズ検証
- [ ] フェーズ6（ゲームロジック）：`services/game` + `providers/game` の基本アクションと特殊アクションのテストが通過
- [ ] フェーズ7（ローカル UI）：各画面のレンダリングと `GameState` 連携を `widget_test` で確認
- [ ] フェーズ8（オンライン同期）：ホスト/ゲストで Firebase Room の CRUD・同期が安定、セキュリティルール適用済み
- [ ] フェーズ9（テスト & QA）：`flutter test`/`integration_test`/`flutter analyze` を完了しドキュメントを更新
