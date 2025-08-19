// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';

//   // SettingScreen:アプリ設定管理ページ
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key}); // ← const: 変わらない部分は最適化

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// // SettingsScreenの状態を管理するクラス
// class _SettingsScreenState extends State<SettingsScreen> {
//   // 入力欄の文字を管理するコントローラ
//   final _vault = TextEditingController();
//   final _folder = TextEditingController();
//   final _datePattern = TextEditingController(text: 'yyyy-MM-dd');

//   late Future<void> _init; // 初期ロードが終わったかを管理する変数

//   @override
//   void initState() {
//     super.initState();
//     _init = _load(); // 画面ができたときにデータを読む
//   }

//   // データを読み込む非同期関数
//   Future<void> _load() async {
//     if (!Hive.isBoxOpen('settings')){
//       await Hive.openBox('settings'); 
//     }
//     final box = Hive.box('settings');
//     _vault.text = (box.get('vault') ?? '') as String;
//     _folder.text = (box.get('folder') ?? '') as String;
//     _datePattern.text = (box.get('datePattern') ?? 'yyyy-MM-dd') as String;
//   }
// }