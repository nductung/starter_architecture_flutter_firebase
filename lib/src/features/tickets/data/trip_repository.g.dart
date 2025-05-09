// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripRepositoryHash() => r'd70b8280053ccbedbcd11072062a578b0f901466';

/// See also [tripRepository].
@ProviderFor(tripRepository)
final tripRepositoryProvider = AutoDisposeProvider<TripRepository>.internal(
  tripRepository,
  name: r'tripRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripRepositoryRef = AutoDisposeProviderRef<TripRepository>;
String _$tripsHash() => r'6a5a2956c9b4c6612de09c0e1d06dba4bdb4bef6';

/// See also [trips].
@ProviderFor(trips)
final tripsProvider = AutoDisposeFutureProvider<List<Trip>>.internal(
  trips,
  name: r'tripsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripsRef = AutoDisposeFutureProviderRef<List<Trip>>;
String _$tripsByRouteHash() => r'a4382a3994545b6e4f4f64322ba153e3c7b1d25c';

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

/// See also [tripsByRoute].
@ProviderFor(tripsByRoute)
const tripsByRouteProvider = TripsByRouteFamily();

/// See also [tripsByRoute].
class TripsByRouteFamily extends Family<AsyncValue<List<Trip>>> {
  /// See also [tripsByRoute].
  const TripsByRouteFamily();

  /// See also [tripsByRoute].
  TripsByRouteProvider call(
    String originCity,
    String destinationCity,
  ) {
    return TripsByRouteProvider(
      originCity,
      destinationCity,
    );
  }

  @override
  TripsByRouteProvider getProviderOverride(
    covariant TripsByRouteProvider provider,
  ) {
    return call(
      provider.originCity,
      provider.destinationCity,
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
  String? get name => r'tripsByRouteProvider';
}

/// See also [tripsByRoute].
class TripsByRouteProvider extends AutoDisposeFutureProvider<List<Trip>> {
  /// See also [tripsByRoute].
  TripsByRouteProvider(
    String originCity,
    String destinationCity,
  ) : this._internal(
          (ref) => tripsByRoute(
            ref as TripsByRouteRef,
            originCity,
            destinationCity,
          ),
          from: tripsByRouteProvider,
          name: r'tripsByRouteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripsByRouteHash,
          dependencies: TripsByRouteFamily._dependencies,
          allTransitiveDependencies:
              TripsByRouteFamily._allTransitiveDependencies,
          originCity: originCity,
          destinationCity: destinationCity,
        );

  TripsByRouteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.originCity,
    required this.destinationCity,
  }) : super.internal();

  final String originCity;
  final String destinationCity;

  @override
  Override overrideWith(
    FutureOr<List<Trip>> Function(TripsByRouteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripsByRouteProvider._internal(
        (ref) => create(ref as TripsByRouteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        originCity: originCity,
        destinationCity: destinationCity,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Trip>> createElement() {
    return _TripsByRouteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripsByRouteProvider &&
        other.originCity == originCity &&
        other.destinationCity == destinationCity;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, originCity.hashCode);
    hash = _SystemHash.combine(hash, destinationCity.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripsByRouteRef on AutoDisposeFutureProviderRef<List<Trip>> {
  /// The parameter `originCity` of this provider.
  String get originCity;

  /// The parameter `destinationCity` of this provider.
  String get destinationCity;
}

class _TripsByRouteProviderElement
    extends AutoDisposeFutureProviderElement<List<Trip>> with TripsByRouteRef {
  _TripsByRouteProviderElement(super.provider);

  @override
  String get originCity => (origin as TripsByRouteProvider).originCity;
  @override
  String get destinationCity =>
      (origin as TripsByRouteProvider).destinationCity;
}

String _$tripHash() => r'160a0671cb2f26f159bdac6aed6af1f05495d892';

/// See also [trip].
@ProviderFor(trip)
const tripProvider = TripFamily();

/// See also [trip].
class TripFamily extends Family<AsyncValue<Trip?>> {
  /// See also [trip].
  const TripFamily();

  /// See also [trip].
  TripProvider call(
    String tripId,
  ) {
    return TripProvider(
      tripId,
    );
  }

  @override
  TripProvider getProviderOverride(
    covariant TripProvider provider,
  ) {
    return call(
      provider.tripId,
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
  String? get name => r'tripProvider';
}

/// See also [trip].
class TripProvider extends AutoDisposeFutureProvider<Trip?> {
  /// See also [trip].
  TripProvider(
    String tripId,
  ) : this._internal(
          (ref) => trip(
            ref as TripRef,
            tripId,
          ),
          from: tripProvider,
          name: r'tripProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$tripHash,
          dependencies: TripFamily._dependencies,
          allTransitiveDependencies: TripFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final String tripId;

  @override
  Override overrideWith(
    FutureOr<Trip?> Function(TripRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripProvider._internal(
        (ref) => create(ref as TripRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Trip?> createElement() {
    return _TripProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripRef on AutoDisposeFutureProviderRef<Trip?> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripProviderElement extends AutoDisposeFutureProviderElement<Trip?>
    with TripRef {
  _TripProviderElement(super.provider);

  @override
  String get tripId => (origin as TripProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
