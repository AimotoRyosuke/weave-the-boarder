import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:weave_the_border/core/constants/app_theme.dart';
import 'package:weave_the_border/providers/online/firebase_provider.dart';
import 'package:weave_the_border/screens/game/game_screen.dart';
import 'package:weave_the_border/screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: WeaveTheBorderApp()));
}

/// アプリ全体を囲むルートウィジェット。
class WeaveTheBorderApp extends ConsumerWidget {
  const WeaveTheBorderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseInit = ref.watch(firebaseAppProvider);

    return MaterialApp(
      title: 'Weave the Border',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: firebaseInit.when(
        data: (_) => const HomeScreen(),
        loading: () => const _LoadingScreen(),
        error: (error, stack) => _ErrorScreen(
          message: error.toString(),
          onRetry: () => ref.invalidate(firebaseAppProvider),
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('初期化エラー')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Firebase の初期化に失敗しました。',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('再試行')),
          ],
        ),
      ),
    );
  }
}
