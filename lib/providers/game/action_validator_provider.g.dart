// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_validator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(actionValidator)
final actionValidatorProvider = ActionValidatorProvider._();

final class ActionValidatorProvider
    extends
        $FunctionalProvider<
          GameActionValidator,
          GameActionValidator,
          GameActionValidator
        >
    with $Provider<GameActionValidator> {
  ActionValidatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionValidatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionValidatorHash();

  @$internal
  @override
  $ProviderElement<GameActionValidator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GameActionValidator create(Ref ref) {
    return actionValidator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameActionValidator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameActionValidator>(value),
    );
  }
}

String _$actionValidatorHash() => r'a1cf3fe7adf951805b25a032dbea4fbc66135191';
