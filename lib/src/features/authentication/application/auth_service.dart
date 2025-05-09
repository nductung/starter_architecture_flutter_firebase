import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/onboarding/data/onboarding_repository.dart';

// Thêm import cho notifications repository
import 'package:starter_architecture_flutter_firebase/src/features/notifications/data/notifications_repository.dart';

part 'auth_service.g.dart';

class AuthService {
  AuthService({required this.authRepository});
  final AuthRepository authRepository;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    
    // Kiểm tra và tạo thông báo chào mừng sau khi đăng nhập thành công
    await _checkAndCreateWelcomeNotification();
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await authRepository.createUserWithEmailAndPassword(
      email,
      password,
    );
    
    // Tạo thông báo chào mừng cho người dùng mới
    await _createWelcomeNotification();
  }
  
  // Thêm phương thức đăng nhập ẩn danh
  Future<void> signInAnonymously() async {
    await authRepository.signInAnonymously();
    
    // Tạo thông báo chào mừng cho người dùng ẩn danh
    await _createWelcomeNotification();
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
  
  // Phương thức tạo thông báo chào mừng
  Future<void> _createWelcomeNotification() async {
    try {
      final user = authRepository.currentUser;
      if (user == null) return;
      
      log('Creating welcome notification for new user: ${user.uid}');
      final firestore = FirebaseFirestore.instance;
      final repository = NotificationsRepository(firestore);
      await repository.createWelcomeNotification(uid: user.uid);
      log('Welcome notification created successfully for new user');
    } catch (e) {
      log('Error creating welcome notification: $e');
      // Không ảnh hưởng đến luồng đăng nhập
    }
  }
  
  // Phương thức kiểm tra và tạo thông báo chào mừng nếu cần
  Future<void> _checkAndCreateWelcomeNotification() async {
    try {
      final user = authRepository.currentUser;
      if (user == null) return;
      
      log('Checking if welcome notification needed for: ${user.uid}');
      final firestore = FirebaseFirestore.instance;
      final repository = NotificationsRepository(firestore);
      
      // Kiểm tra xem người dùng đã có thông báo nào chưa
      final notifications = await repository.getNotifications(
        uid: user.uid,
        pageSize: 1,
      );
      
      if (notifications.docs.isEmpty) {
        log('No notifications found, creating welcome notification');
        await repository.createWelcomeNotification(uid: user.uid);
        log('Welcome notification created successfully after login');
      } else {
        log('User already has notifications, welcome not needed');
      }
    } catch (e) {
      log('Error checking/creating welcome notification: $e');
      // Không ảnh hưởng đến luồng đăng nhập
    }
  }
}

@riverpod
AuthService authService(AuthServiceRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthService(authRepository: authRepository);
} 