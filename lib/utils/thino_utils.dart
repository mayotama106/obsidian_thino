import 'package:intl/intl.dart';

String toThinoLine(String text, {DateTime? now}) {
  // 文字列の前後の空白を削除
  final trimmedText = text.trim();
  // もし空文字列なら何もしない
  if (trimmedText.isEmpty) return '';
  // 現在の日時を取得
  final t = now ?? DateTime.now();
  // 現在の日時を取得
  final hhmm = DateFormat('HH:mm').format(t);

  return '- $hhmm $trimmedText';
}

String normalizePath(String path) {
  // パスの先頭と末尾のスラッシュを削除
  return path
      .replaceAll(RegExp(r'^/+'), '')
      .replaceAll(RegExp(r'/+$'), '');
      
}

class DailyAppendConfig {
  final String vaultEncoded;   // 例: "My%20Vault"（保存時にエンコード済みを入れる）
  final String dailyFolder;    // 例: "Thino/Daily"（先頭/末尾のスラッシュは後で整える）
  final String datePattern;    // 例: "yyyy-MM-dd"（Thino設定に合わせる）

  const DailyAppendConfig({
    required this.vaultEncoded,
    required this.dailyFolder,
    required this.datePattern,
  });
}
