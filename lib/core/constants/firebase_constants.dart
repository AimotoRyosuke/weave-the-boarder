import 'package:firebase_core/firebase_core.dart';

/// 実際の Firebase 構成をここで管理する。
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: 'REPLACE_WITH_YOUR_API_KEY',
  appId: 'REPLACE_WITH_YOUR_APP_ID',
  messagingSenderId: 'REPLACE_WITH_YOUR_MESSAGING_SENDER_ID',
  projectId: 'weave-the-border',
  storageBucket: 'weave-the-border.appspot.com',
  databaseURL: 'https://weave-the-border-default-rtdb.firebaseio.com',
);
