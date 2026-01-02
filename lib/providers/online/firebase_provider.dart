import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:weave_the_border/firebase_options.dart';

part 'firebase_provider.g.dart';

/// Firebase 初期化を Riverpod で扱うためのプロバイダー。
@riverpod
Future<FirebaseApp> firebaseApp(Ref ref) async {
  // 将来的に環境ごとのオプションを切り替えられるようにするかも
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
