import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/async_value_widget.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/application/notifications_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/domain/notification.dart'
    as app;
import 'package:starter_architecture_flutter_firebase/src/features/notifications/presentation/notification_item.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    // Đảm bảo controller được khởi tạo
    Future.microtask(() {
      ref.read(notificationsControllerProvider);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng Stream và Cache cho trải nghiệm người dùng mượt mà hơn
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final cachedNotifications = ref.watch(notificationsCacheProvider);

    // Nếu có dữ liệu trong cache và stream đang loading, hiển thị dữ liệu từ cache
    if (notificationsAsync.isLoading && cachedNotifications.isNotEmpty) {
      return _buildScaffold(AsyncData(cachedNotifications));
    }

    return _buildScaffold(notificationsAsync);
  }

  Widget _buildScaffold(AsyncValue<List<app.Notification>> notificationsAsync) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'notifications'.tr(context),
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.done_all, color: Colors.white),
                            onPressed: () => ref.read(
                                markAllNotificationsAsReadProvider.future),
                            tooltip: 'mark_all_as_read'.tr(context),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              ref.invalidate(notificationsStreamProvider);
                            },
                            tooltip: 'refresh'.tr(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notification container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: notificationsAsync.when(
                        data: (notifications) {
                          if (notifications.isEmpty) {
                            return _buildEmptyState();
                          }

                          // Sắp xếp thông báo theo thời gian (mới nhất đầu tiên)
                          final sortedNotifications = [...notifications]
                            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

                          return ModernNotificationsList(
                            notifications: sortedNotifications,
                            animationController: _animationController,
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => _buildErrorState(error),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: theme.primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'no_notifications'.tr(context),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'notifications_appear_here'.tr(context),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'error_occurred'.tr(context),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(notificationsStreamProvider);
              },
              icon: const Icon(Icons.refresh),
              label: Text('try_again'.tr(context)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernNotificationsList extends StatelessWidget {
  const ModernNotificationsList({
    required this.notifications,
    required this.animationController,
    super.key,
  });

  final List<app.Notification> notifications;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        final ref = ProviderScope.containerOf(context, listen: false);
        ref.invalidate(notificationsStreamProvider);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildAnimatedNotificationItem(context, notification, index);
        },
      ),
    );
  }

  Widget _buildAnimatedNotificationItem(
      BuildContext context, app.Notification notification, int index) {
    final theme = Theme.of(context);

    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        min(0.8, index * 0.05),  // Giảm delay giữa các item
        min(1.0, index * 0.05 + 0.1),
        curve: Curves.easeOut,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            color: notification.read 
                ? Colors.white
                : theme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: notification.read 
                  ? Colors.grey.withOpacity(0.2)
                  : theme.primaryColor.withOpacity(0.3),
              width: notification.read ? 1 : 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: NotificationItem(
              notification: notification,
            ),
          ),
        ),
      ),
    );
  }
}
