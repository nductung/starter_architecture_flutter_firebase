// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ticketRepositoryHash() => r'7a8bc2d796b719d3553c57e534a16f7107a40c51';

/// See also [ticketRepository].
@ProviderFor(ticketRepository)
final ticketRepositoryProvider = AutoDisposeProvider<TicketRepository>.internal(
  ticketRepository,
  name: r'ticketRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ticketRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TicketRepositoryRef = AutoDisposeProviderRef<TicketRepository>;
String _$userTicketsHash() => r'e786a5183863e78d370c31243ed46d9b25f2d73f';

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

/// See also [userTickets].
@ProviderFor(userTickets)
const userTicketsProvider = UserTicketsFamily();

/// See also [userTickets].
class UserTicketsFamily extends Family<AsyncValue<List<Ticket>>> {
  /// See also [userTickets].
  const UserTicketsFamily();

  /// See also [userTickets].
  UserTicketsProvider call(
    String userId,
  ) {
    return UserTicketsProvider(
      userId,
    );
  }

  @override
  UserTicketsProvider getProviderOverride(
    covariant UserTicketsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userTicketsProvider';
}

/// See also [userTickets].
class UserTicketsProvider extends AutoDisposeFutureProvider<List<Ticket>> {
  /// See also [userTickets].
  UserTicketsProvider(
    String userId,
  ) : this._internal(
          (ref) => userTickets(
            ref as UserTicketsRef,
            userId,
          ),
          from: userTicketsProvider,
          name: r'userTicketsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userTicketsHash,
          dependencies: UserTicketsFamily._dependencies,
          allTransitiveDependencies:
              UserTicketsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserTicketsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Ticket>> Function(UserTicketsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserTicketsProvider._internal(
        (ref) => create(ref as UserTicketsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Ticket>> createElement() {
    return _UserTicketsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserTicketsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserTicketsRef on AutoDisposeFutureProviderRef<List<Ticket>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserTicketsProviderElement
    extends AutoDisposeFutureProviderElement<List<Ticket>> with UserTicketsRef {
  _UserTicketsProviderElement(super.provider);

  @override
  String get userId => (origin as UserTicketsProvider).userId;
}

String _$userTicketsStreamHash() => r'095805bd8ba511c8eea6bfb5239b3f97685f2564';

/// See also [userTicketsStream].
@ProviderFor(userTicketsStream)
const userTicketsStreamProvider = UserTicketsStreamFamily();

/// See also [userTicketsStream].
class UserTicketsStreamFamily extends Family<AsyncValue<List<Ticket>>> {
  /// See also [userTicketsStream].
  const UserTicketsStreamFamily();

  /// See also [userTicketsStream].
  UserTicketsStreamProvider call(
    String userId,
  ) {
    return UserTicketsStreamProvider(
      userId,
    );
  }

  @override
  UserTicketsStreamProvider getProviderOverride(
    covariant UserTicketsStreamProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userTicketsStreamProvider';
}

/// See also [userTicketsStream].
class UserTicketsStreamProvider
    extends AutoDisposeStreamProvider<List<Ticket>> {
  /// See also [userTicketsStream].
  UserTicketsStreamProvider(
    String userId,
  ) : this._internal(
          (ref) => userTicketsStream(
            ref as UserTicketsStreamRef,
            userId,
          ),
          from: userTicketsStreamProvider,
          name: r'userTicketsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userTicketsStreamHash,
          dependencies: UserTicketsStreamFamily._dependencies,
          allTransitiveDependencies:
              UserTicketsStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserTicketsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<Ticket>> Function(UserTicketsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserTicketsStreamProvider._internal(
        (ref) => create(ref as UserTicketsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Ticket>> createElement() {
    return _UserTicketsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserTicketsStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserTicketsStreamRef on AutoDisposeStreamProviderRef<List<Ticket>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserTicketsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Ticket>>
    with UserTicketsStreamRef {
  _UserTicketsStreamProviderElement(super.provider);

  @override
  String get userId => (origin as UserTicketsStreamProvider).userId;
}

String _$ticketHash() => r'9aaeb67aac12da6131370d8ef02d27707badbd17';

/// See also [ticket].
@ProviderFor(ticket)
const ticketProvider = TicketFamily();

/// See also [ticket].
class TicketFamily extends Family<AsyncValue<Ticket?>> {
  /// See also [ticket].
  const TicketFamily();

  /// See also [ticket].
  TicketProvider call(
    String ticketId,
  ) {
    return TicketProvider(
      ticketId,
    );
  }

  @override
  TicketProvider getProviderOverride(
    covariant TicketProvider provider,
  ) {
    return call(
      provider.ticketId,
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
  String? get name => r'ticketProvider';
}

/// See also [ticket].
class TicketProvider extends AutoDisposeFutureProvider<Ticket?> {
  /// See also [ticket].
  TicketProvider(
    String ticketId,
  ) : this._internal(
          (ref) => ticket(
            ref as TicketRef,
            ticketId,
          ),
          from: ticketProvider,
          name: r'ticketProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ticketHash,
          dependencies: TicketFamily._dependencies,
          allTransitiveDependencies: TicketFamily._allTransitiveDependencies,
          ticketId: ticketId,
        );

  TicketProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ticketId,
  }) : super.internal();

  final String ticketId;

  @override
  Override overrideWith(
    FutureOr<Ticket?> Function(TicketRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TicketProvider._internal(
        (ref) => create(ref as TicketRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ticketId: ticketId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Ticket?> createElement() {
    return _TicketProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TicketProvider && other.ticketId == ticketId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ticketId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TicketRef on AutoDisposeFutureProviderRef<Ticket?> {
  /// The parameter `ticketId` of this provider.
  String get ticketId;
}

class _TicketProviderElement extends AutoDisposeFutureProviderElement<Ticket?>
    with TicketRef {
  _TicketProviderElement(super.provider);

  @override
  String get ticketId => (origin as TicketProvider).ticketId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
