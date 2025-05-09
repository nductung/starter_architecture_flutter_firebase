import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/data/notifications_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/domain/notification.dart' as app;

part 'notifications_controller.g.dart';

// Quan trọng: đây là cách tiếp cận đơn giản hóa, không kiểm tra thông báo chào mừng tại đây nữa
@riverpod
Stream<List<app.Notification>> notificationsStream(NotificationsStreamRef ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;
  
  if (user == null) {
    log('User is null in notificationsStream');
    return Stream.value([]);
  }
  
  log('Setting up notifications stream for user: ${user.uid}');
  final repository = ref.watch(notificationsRepositoryProvider);
  
  // Lưu ý: loại bỏ sự phụ thuộc vào welcomeNotificationInitialized
  return repository.watchNotifications(uid: user.uid);
}

// Cache dữ liệu thông báo để tránh phải reload
@riverpod
class NotificationsCache extends _$NotificationsCache {
  @override
  List<app.Notification> build() {
    // Khởi tạo với danh sách rỗng
    return [];
  }

  // Thêm danh sách thông báo vào cache
  void addNotifications(List<app.Notification> notifications) {
    // Chỉ thêm các thông báo chưa có trong cache
    final existingIds = state.map((n) => n.id).toSet();
    final newNotifications = notifications.where((n) => !existingIds.contains(n.id)).toList();
    
    if (newNotifications.isNotEmpty) {
      state = [...state, ...newNotifications];
    }
  }
  
  // Cập nhật trạng thái đọc của một thông báo
  void markAsRead(app.NotificationID notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(read: true);
      }
      return notification;
    }).toList();
  }
  
  // Đánh dấu tất cả đã đọc
  void markAllAsRead() {
    state = state.map((notification) => notification.copyWith(read: true)).toList();
  }
  
  // Xóa cache
  void clear() {
    state = [];
  }
}

// Provider để kiểm soát trạng thái đọc của thông báo
@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Future<void> build() async {
    // Đăng ký lắng nghe stream thông báo và cập nhật cache
    ref.listen<AsyncValue<List<app.Notification>>>(
      notificationsStreamProvider,
      (_, next) {
        next.whenData((notifications) {
          ref.read(notificationsCacheProvider.notifier).addNotifications(notifications);
        });
      },
    );
  }

  Future<void> markAsRead(app.NotificationID notificationId) async {
    try {
      final auth = ref.read(firebaseAuthProvider);
      final user = auth.currentUser;
      if (user == null) return;

      log('Marking notification as read: $notificationId');
      final repository = ref.read(notificationsRepositoryProvider);
      await repository.markAsRead(uid: user.uid, notificationId: notificationId);
      
      // Cập nhật cache
      ref.read(notificationsCacheProvider.notifier).markAsRead(notificationId);
    } catch (e) {
      log('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final auth = ref.read(firebaseAuthProvider);
      final user = auth.currentUser;
      if (user == null) return;

      log('Marking all notifications as read');
      final repository = ref.read(notificationsRepositoryProvider);
      await repository.markAllAsRead(uid: user.uid);
      
      // Cập nhật cache
      ref.read(notificationsCacheProvider.notifier).markAllAsRead();
    } catch (e) {
      log('Error marking all notifications as read: $e');
    }
  }
}

@riverpod
Future<void> markNotificationAsRead(Ref ref, app.NotificationID notificationId) async {
  log('Calling markNotificationAsRead for: $notificationId');
  final controller = ref.read(notificationsControllerProvider.notifier);
  await controller.markAsRead(notificationId);
}

@riverpod
Future<void> markAllNotificationsAsRead(Ref ref) async {
  log('Calling markAllNotificationsAsRead');
  final controller = ref.read(notificationsControllerProvider.notifier);
  await controller.markAllAsRead();
} 