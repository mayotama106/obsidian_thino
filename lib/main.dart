// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/thino_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CapturePage());
  }
}

// このクラスは、メモを入力してローカルに保存するページです。
// Hiveを使用して、メモの保存と表示を行います。
class CapturePage extends StatefulWidget {
  const CapturePage({super.key});
  @override
  State<CapturePage> createState() => _CapturePageState();
}

// CapturePageの状態を管理するクラスです。
// メモの入力、保存、表示、削除を行う。
// Hiveを使用してローカルに保存されたメモを管理する。
// メモは新しい順に表示され、スワイプで削除する。
class _CapturePageState extends State<CapturePage> {
  final _c = TextEditingController();

  Future<void> _save() async {
    final line = toThinoLine(_c.text);
    if (line.isEmpty) return;
    final box = Hive.box('notes');
     //await の前に Messenger を取得（context をまたがない）
    final messenger = ScaffoldMessenger.of(context);

    await box.add({
      'text': line,
      'createdAt': DateTime.now().toIso8601String(),
    });
     if (!context.mounted) return; // 画面が閉じている場合は何もしない
    // 入力フィールドをクリア
    _c.clear();
    messenger.showSnackBar(
      SnackBar(content: Text('$line \nを保存しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('notes'); 
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Capture')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _c,
                  decoration: const InputDecoration(hintText: 'メモを入力'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('ローカル保存'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('保存したノート一覧'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box notes, _) {
                if (notes.isEmpty) {
                  return const Center(child: Text("まだノートがありません"));
                }

                // ▼ ここを「entries（key,value）」にして新しい順に表示
                final entries = notes.toMap().entries.toList()
                  ..sort((a, b) => b.key.toString().compareTo(a.key.toString()));

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (_, i) {
                    final e = entries[i];
                    final key = e.key; //メモの削除・復元に使用
                    final value = Map<String, dynamic>.from(e.value);

                    // ▼ スワイプ削除（右→左）
                    return Dismissible(
                      key: ValueKey(key),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      // スワイプが完了したら、該当のメモを削除
                      // 注意: 非同期処理のため、awaitを使用
                      onDismissed: (_) async {
                        //　削除取消用にバックアップを保存
                        final backupKey = key;
                        final backupValue = Map<String, dynamic>.from(value);

                        //await の前に Messenger を取得（context をまたがない）
                        final messenger = ScaffoldMessenger.of(context);
                        
                        await notes.delete(backupKey);
                        // スナックバーで削除完了を通知
                        if (!context.mounted) return; // 画面が閉じている場合は何もしない
                        messenger.clearSnackBars();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('メモを削除しました: ${backupValue['text']}'),
                            action: SnackBarAction(
                              label: '元に戻す',
                              // もとに戻すボタンが押されたら、削除を取り消す
                              onPressed: () async {
                                // 削除を取り消すために、バックアップから復元
                                await notes.put(backupKey, backupValue);
                                messenger.showSnackBar(
                                  SnackBar(content: Text('メモを復元しました')),
                                );
                              },
                            ),
                            // 取り消すまでの時間を用意
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          value['text']?.toString() ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(value['createdAt']?.toString() ?? ''),
                        trailing: const Icon(Icons.chevron_left), // スワイプ誘導
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
