import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weave_the_border/screens/game/local_game_screen.dart'; // Add this import
import 'package:weave_the_border/widgets/glassy_choice_card.dart';
import 'package:weave_the_border/models/game_mode.dart';

/// フェーズ4では仮UIとしてモード選択のカードを表示。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _navigateToLocalGameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocalGameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/img/background.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 24,
            left: 12,
            right: 12,
            child: Image.asset('assets/img/title.png'),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ModeCard(
                    mode: GameMode.local,
                    onTap: () {
                      _navigateToLocalGameScreen(context);
                    },
                  ),
                  const Gap(16),
                  _ModeCard(
                    mode: GameMode.online,
                    onTap: () {
                      // オンライン対戦画面への遷移は未実装
                    },
                  ),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.onTap});

  final GameMode mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassyChoiceCard(
      title: mode.title,
      description: mode.description,
      icon: mode.icon,
      accentColor: mode.accentColor,
      onTap: onTap,
    );
  }
}
