// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsStreamHash() =>
    r'b28fc32f4f955a1bbfa59c441f07515515bd43b0';

/// See also [notificationsStream].
@ProviderFor(notificationsStream)
final notificationsStreamProvider =
    AutoDisposeStreamProvider<List<app.Notification>>.internal(
  notificationsStream,
  name: r'notificationsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsStreamRef
    = AutoDisposeStreamProviderRef<List<app.Notification>>;
String _$markNotificationAsReadHash() =>
    r'3abcc00140e668d6c3453b2a252f9097f3992d13';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [markNotificationAsRead].
@ProviderFor(markNotificationAsRead)
const markNotificationAsReadProvider = MarkNotificationAsReadFamily();

/// See also [markNotificationAsRead].
class MarkNotificationAsReadFamily extends Family<AsyncValue<void>> {
  /// See also [markNotificationAsRead].
  const MarkNotificationAsReadFamily();

  /// See also [markNotificationAsRead].
  MarkNotificationAsReadProvider call(
    String notificationId,
  ) {
    return MarkNotificationAsReadProvider(
      notificationId,
    );
  }

  @override
  MarkNotificationAsReadProvider getProviderOverride(
    covariant MarkNotificationAsReadProvider provider,
  ) {
    return call(
      provider.notificationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'markNotificationAsReadProvider';
}

/// See also [markNotificationAsRead].
class MarkNotificationAsReadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [markNotificationAsRead].
  MarkNotificationAsReadProvider(
    String notificationId,
  ) : this._internal(
          (ref) => markNotificationAsRead(
            ref as MarkNotificationAsReadRef,
            notificationId,
          ),
          from: markNotificationAsReadProvider,
          name: r'markNotificationAsReadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$markNotificationAsReadHash,
          dependencies: MarkNotificationAsReadFamily._dependencies,
          allTransitiveDependencies:
              MarkNotificationAsReadFamily._allTransitiveDependencies,
          notificationId: notificationId,
        );

  MarkNotificationAsReadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.notificationId,
  }) : super.internal();

  final String notificationId;

  @override
  Override overrideWith(
    FutureOr<void> Function(MarkNotificationAsReadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarkNotificationAsReadProvider._internal(
        (ref) => create(ref as MarkNotificationAsReadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        notificationId: notificationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _MarkNotificationAsReadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarkNotificationAsReadProvider &&
        other.notificationId == notificationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notificationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarkNotificationAsReadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `notificationId` of this provider.
  String get notificationId;
}

class _MarkNotificationAsReadProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with MarkNotificationAsReadRef {
  _MarkNotificationAsReadProviderElement(super.provider);

  @override
  String get notificationId =>
      (origin as MarkNotificationAsReadProvider).notificationId;
}

String _$markAllNotificationsAsReadHash() =>
    r'342c74b9bc0a19b12a82f91a36cb77a3dfcba417';

/// See also [markAllNotificationsAsRead].
@ProviderFor(markAllNotificationsAsRead)
final markAllNotificationsAsReadProvider =
    AutoDisposeFutureProvider<void>.internal(
  markAllNotificationsAsRead,
  name: r'markAllNotificationsAsReadProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$markAllNotificationsAsReadHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarkAllNotificationsAsReadRef = AutoDisposeFutureProviderRef<void>;
String _$notificationsCacheHash() =>
    r'8305ecf052a4a695badd0d510e59fe404c24fe10';

/// See also [NotificationsCache].
@ProviderFor(NotificationsCache)
final notificationsCacheProvider = AutoDisposeNotifierProvider<
    NotificationsCache, List<app.Notification>>.internal(
  NotificationsCache.new,
  name: r'notificationsCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsCache = AutoDisposeNotifier<List<app.Notification>>;
String _$notificationsControllerHash() =>
    r'c2ef9ddf5ef0973b4181a14afd35eef1b7454595';

/// See also [NotificationsController].
@ProviderFor(NotificationsController)
final notificationsControllerProvider =
    AutoDisposeAsyncNotifierProvider<NotificationsController, void>.internal(
  NotificationsController.new,
  name: r'notificationsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
