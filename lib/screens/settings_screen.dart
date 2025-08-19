import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _vault = TextEditingController();
  final _folder = TextEditingController();
  final _datePattern = TextEditingController(text: 'yyyy-MM-dd');

  late Future<void> _init;

  @override
  void initState() {
    super.initState();
    _init = _load(); // 初期化処理を非同期で実行
  }

  // 設定をロードするメソッド
  // Hiveの設定ボックスから値を取得し、コントローラーにセット
  // 初回起動時に呼び出される
  Future<void> _load() async {
    if (!Hive.isBoxOpen('settings')) {
      await Hive.openBox('settings');
    }
    final box = Hive.box('settings');
    _vault.text = (box.get('vault') ?? '') as String;
    _folder.text = (box.get('folder') ?? '') as String;
    _datePattern.text = (box.get('datePattern') ?? 'yyyy-MM-dd') as String;
  }

  // 設定を保存するメソッド
  // コントローラーの値をHiveの設定ボックスに保存
  Future<void> _save() async {
    final box = Hive.box('settings');
    await box.put('vault', _vault.text.trim());
    await box.put('folder', _folder.text.trim());
    await box.put('datePattern', _datePattern.text.trim());

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(const SnackBar(content: Text('設定を保存しました')));
  }

  @override
  void dispose() {
    _vault.dispose();
    _folder.dispose();
    _datePattern.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return  Scaffold(
            appBar: AppBar(title: Text('設定')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('設定')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Obsidian 連携', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _vault,
                decoration: const InputDecoration(
                  labelText: 'Vault 名（URLエンコード前）',
                  hintText: '例: My Vault',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _folder,
                decoration: const InputDecoration(
                  labelText: 'Daily フォルダ',
                  hintText: '例: Thino/Daily',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _datePattern,
                decoration: const InputDecoration(
                  labelText: '日付パターン',
                  hintText: '例: yyyy-MM-dd',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: const Text('保存'),
              ),
            ],
          ),
        );
      },
    );
  }
}
