// capture_screen.dart の一部抜粋（List表示の差し替え）

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThinoList extends StatefulWidget {
  const ThinoList({super.key, required this.boxName});
  final String boxName;

  @override
  State<ThinoList> createState() => _ThinoListState();
}

class _ThinoListState extends State<ThinoList> {
  late Future<void> _init;

  @override
  void initState() {
    super.initState();
    _init = _ensureBox();
  }

  Future<void> _ensureBox() async {
    // すでに init 済みなら何もしない
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(widget.boxName)) {
      await Hive.openBox(widget.boxName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final box = Hive.box(widget.boxName);

        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, _, __) {
            // Map<key, value> として取得し、新しい順（key降順）に並べる
            final entries = box.toMap().entries.toList();
            entries.sort((a, b) {
              // key が num / String どちらでも動くように文字列化比較
              return b.key.toString().compareTo(a.key.toString());
            });

            if (entries.isEmpty) {
              return const Center(child: Text('まだ何もありません'));
            }

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final entry = entries[i];
                final key = entry.key;         // Hiveのキー（削除に使う）
                final value = entry.value;     // 1行テキスト想定（String）

                return Dismissible(
                  key: ValueKey(key),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await box.delete(key);  // ← 実削除
                    if (!context.mounted) return;
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('削除しました')),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      value.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_left), // スワイプ誘導
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
