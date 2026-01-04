# Copilot Agent Instructions

## コーディングルール

- importは相対パスではなくpackageの絶対パスで行なってください。
- freezedクラスは`sealed class`として定義し、フリーザーミックスインの要求を満たすようにしてください。
- enumには `@JsonEnum` を付けないでください。
- モデルクラスのフィールドにfreezedのクラスが入る時はそのfactoryに`@JsonSerializable(explicitToJson: true)`を付けてください。
- enumのextentionは作らず、enumにgetterや関数を作成するようにしてください。
- コード内のコメントは日本語で記載してください。

## テスト

- groupやtestの説明は日本語で記載すること

## 返事のルール

- このリポジトリでは、ユーザーからの指示に対して**常に日本語**で応答してください。
- 質問や変更を行う前に `docs/ARCHITECTURE.md` や `RULE.md` を参照し、開発方針やゲームのルールに沿って答えてください。
- 変更を加える際は、可能な限り `flutter doctor` や `flutter pub get` などのセットアップ手順を確認し、必要に応じて依存関係の整合性を保ってください。
- Copilot に直接変更できない設定やルールに関する要望は、代わりにこのファイルに記述し、その内容を尊重しながら対応してください。
- 変更提案では、技術的根拠と次のステップを簡潔に伝えるようにしてください。
