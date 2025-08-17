# 実装ログ

## 2025-08-17
- 1.4 スワイプ削除 Step A を `lib/main.dart` に最小改修で導入。
  - Box名の不一致（`Notes`→`notes`）を修正。
  - `Dismissible` でスワイプ削除を実装、SnackBarで通知。
- Git 連携 初期化:
  - `.gitignore` を Flutter 向けに追加。
  - `README.md` と本ログを作成。

## 次の予定
- 4.2 ブランチ運用ルール（命名規則・Conventional Commits）を決定。
- 4.3 PR フロー（レビュー/マージ方針：Squash）を整備。
- 1.4 Step B（Undo 付き）を **feature ブランチ** で実装→PR。
