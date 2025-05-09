import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/custom_profile_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/home/presentation/home_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/tickets/presentation/my_tickets_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/tickets/presentation/ticket_booking_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/tickets/presentation/trip_list_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/presentation/notifications_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/onboarding/data/onboarding_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/not_found_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _ticketsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'tickets');
final _notificationsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'notifications');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

enum AppRoute {
  onboarding,
  signIn,
  home,
  trips,
  bookTicket,
  myTickets,
  notifications,
  profile,
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    //debugLogDiagnostics: true,
    redirect: (context, state) {
      final onboardingRepository =
          ref.read(onboardingRepositoryProvider).requireValue;
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/onboarding') {
          return '/onboarding';
        }
        return null;
      }
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith('/onboarding') || path.startsWith('/signIn')) {
          return '/home';
        }
      } else {
        if (path.startsWith('/onboarding') ||
            path.startsWith('/home') ||
            path.startsWith('/trips') ||
            path.startsWith('/book-ticket') ||
            path.startsWith('/my-tickets') ||
            path.startsWith('/notifications') ||
            path.startsWith('/account')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomSignInScreen(),
        ),
      ),
      GoRoute(
        path: '/book-ticket',
        name: AppRoute.bookTicket.name,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            child: TicketBookingScreen(
              trip: extra?['trip'],
              date: extra?['date'],
            ),
          );
        },
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
        ),
        branches: [
          // Home tab (Trip List)
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TripListScreen(),
                ),
              ),
            ],
          ),
          // My Tickets tab
          StatefulShellBranch(
            navigatorKey: _ticketsNavigatorKey,
            routes: [
              GoRoute(
                path: '/my-tickets',
                name: AppRoute.myTickets.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MyTicketsScreen(),
                ),
              ),
            ],
          ),
          // Notifications tab
          StatefulShellBranch(
            navigatorKey: _notificationsNavigatorKey,
            routes: [
              GoRoute(
                path: '/notifications',
                name: AppRoute.notifications.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: NotificationsScreen(),
                ),
              ),
            ],
          ),
          // Account tab
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: '/account',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CustomProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
