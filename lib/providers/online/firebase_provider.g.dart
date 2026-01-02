// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Firebase 初期化を Riverpod で扱うためのプロバイダー。

@ProviderFor(firebaseApp)
final firebaseAppProvider = FirebaseAppProvider._();

/// Firebase 初期化を Riverpod で扱うためのプロバイダー。

final class FirebaseAppProvider
    extends
        $FunctionalProvider<
          AsyncValue<FirebaseApp>,
          FirebaseApp,
          FutureOr<FirebaseApp>
        >
    with $FutureModifier<FirebaseApp>, $FutureProvider<FirebaseApp> {
  /// Firebase 初期化を Riverpod で扱うためのプロバイダー。
  FirebaseAppProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAppProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAppHash();

  @$internal
  @override
  $FutureProviderElement<FirebaseApp> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FirebaseApp> create(Ref ref) {
    return firebaseApp(ref);
  }
}

String _$firebaseAppHash() => r'504316ad24236accab06f9389afff19e5ad8f8a1';
