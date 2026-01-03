// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Action)
final actionProvider = ActionProvider._();

final class ActionProvider extends $NotifierProvider<Action, ActionState> {
  ActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionHash();

  @$internal
  @override
  Action create() => Action();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionState>(value),
    );
  }
}

String _$actionHash() => r'41ea5129ef5669a2dfcef37618292db183fbcbc2';

abstract class _$Action extends $Notifier<ActionState> {
  ActionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActionState, ActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActionState, ActionState>,
              ActionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
