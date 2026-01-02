import 'package:flutter/material.dart';

/// フェーズ4では仮UIとしてモード選択のカードを表示。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _modeCards = [
    _ModeCard(title: 'ローカル対戦', description: '1台の端末で2人プレイするモード。'),
    _ModeCard(title: 'オンライン対戦', description: 'Firebase と同期して遠隔のプレイヤーと対戦。'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weave the Border'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'どちらの対戦モードで始めますか？',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ..._modeCards,
            const SizedBox(height: 24),
            Text(
              'この画面はフェーズ4の環境構築完了後に詳細実装を進めます。',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
