import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weave_the_border/screens/game/game_screen.dart'; // Add this import

/// フェーズ4では仮UIとしてモード選択のカードを表示。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _navigateToGameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(48),
            const Text(
              '塗り潰せ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const Gap(24),
            const Text(
              'どちらの対戦モードで始めますか？',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Gap(16),
            _ModeCard(
              title: 'ローカル対戦',
              description: '1台の端末で2人プレイするモード。',
              onTap: () => _navigateToGameScreen(context), // contextをキャプチャ
            ),
            const _ModeCard(
              title: 'オンライン対戦',
              description: 'Firebase と同期して遠隔のプレイヤーと対戦。',
            ),
            const Gap(24),
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
  const _ModeCard({required this.title, required this.description, this.onTap});

  final String title;
  final String description;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
