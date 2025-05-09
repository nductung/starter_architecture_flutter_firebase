import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/domain/notification.dart' as app;

part 'notifications_repository.g.dart';

class NotificationsRepository {
  const NotificationsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String notificationPath(String uid, String notificationId) =>
      'users/$uid/notifications/$notificationId';
  static String notificationsPath(String uid) => 'users/$uid/notifications';

  // Create a welcome notification for first-time users
  Future<void> createWelcomeNotification({required UserID uid}) =>
      _firestore.collection(notificationsPath(uid)).add({
        'title': 'Chào mừng',
        'message': 'Chào mừng bạn đến với ứng dụng của chúng tôi!',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

  // Create a notification
  Future<void> addNotification({
    required UserID uid,
    required String title,
    required String message,
  }) =>
      _firestore.collection(notificationsPath(uid)).add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

  // Mark notification as read
  Future<void> markAsRead({
    required UserID uid,
    required app.NotificationID notificationId,
  }) =>
      _firestore.doc(notificationPath(uid, notificationId)).update({
        'read': true,
      });

  // Mark all notifications as read
  Future<void> markAllAsRead({required UserID uid}) async {
    final batch = _firestore.batch();
    final querySnapshot = await _firestore.collection(notificationsPath(uid)).get();
    
    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    
    return batch.commit();
  }

  // Delete notification
  Future<void> deleteNotification({
    required UserID uid,
    required app.NotificationID notificationId,
  }) =>
      _firestore.doc(notificationPath(uid, notificationId)).delete();

  // Get paginated notifications
  Future<QuerySnapshot<app.Notification>> getNotifications({
    required UserID uid,
    DocumentSnapshot? startAfterDocument,
    int pageSize = 10,
  }) {
    Query<app.Notification> query = _firestore
        .collection(notificationsPath(uid))
        .orderBy('timestamp', descending: true)
        .limit(pageSize)
        .withConverter<app.Notification>(
          fromFirestore: (snapshot, _) =>
              app.Notification.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (notification, _) => notification.toMap(),
        );

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  // Watch all notifications
  Stream<List<app.Notification>> watchNotifications({required UserID uid}) =>
      _firestore
          .collection(notificationsPath(uid))
          .orderBy('timestamp', descending: true)
          .withConverter<app.Notification>(
            fromFirestore: (snapshot, _) =>
                app.Notification.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (notification, _) => notification.toMap(),
          )
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(FirebaseFirestore.instance);
}

@riverpod
Future<bool> checkFirstTimeLogin(Ref ref) async {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when checking first-time login');
  }
  
  final firestore = FirebaseFirestore.instance;
  final userDoc = await firestore.doc('users/${user.uid}').get();
  
  return !userDoc.exists;
} 