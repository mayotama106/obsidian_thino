# Obsidian + Thino（Flutter）
iphoneでtwitterのようにobsidianへメモできるアプリ

## 進行マップ（記録）
0. プロジェクト構成
1. キャプチャ機能
  - 1.1 Thino形式の行生成 ✅
  - 1.2 Hive保存 & 一覧表示 ✅
  - 1.3 新しい順表示 ✅
  - 1.4 削除機能（スワイプ削除） → 実装中
  - 1.5 Obsidian append（filepath直指定）
2. ユーティリティ整理
  - 2.1 toThinoLine を utils へ ✅
  - 2.2 normalizeFolder を utils へ ✅
  - 2.3 buildFilepathEncoded を utils/obsidian_utils.dart に実装　
  - 2.4 appendToDailyFilepath を utils/obsidian_utils.dart に実装 
3. 応用機能（予定）
  - 3.1 設定UI（Vault名・フォルダ・フォーマット編集）
  - 3.2 再送キュー管理（失敗時 Hiveへログ）
  - 3.3 重複防止ID付与

詳細ログは [`docs/dev-log.md`](docs/dev-log.md) を参照。


