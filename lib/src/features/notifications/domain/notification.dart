import 'package:cloud_firestore/cloud_firestore.dart';

/// Type defining a notification ID from Firebase.
typedef NotificationID = String;

/// Simple class representing a notification.
class Notification {
  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.read = false,
  });

  final NotificationID id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;

  factory Notification.fromMap(Map<String, dynamic> data, String id) {
    // Xử lý trường hợp timestamp là null (có thể xảy ra khi serverTimestamp chưa được giải quyết)
    final timestampData = data['timestamp'];
    DateTime dateTime;
    
    if (timestampData == null) {
      // Nếu timestamp là null, sử dụng thời gian hiện tại
      dateTime = DateTime.now();
    } else if (timestampData is Timestamp) {
      // Nếu là Timestamp, chuyển đổi thành DateTime
      dateTime = timestampData.toDate();
    } else {
      // Trường hợp khác (không nên xảy ra nhưng phòng hờ)
      dateTime = DateTime.now();
    }
    
    return Notification(
      id: id,
      title: data['title'] as String,
      message: data['message'] as String,
      timestamp: dateTime,
      read: data['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'read': read,
    };
  }

  Notification copyWith({
    String? title,
    String? message,
    DateTime? timestamp,
    bool? read,
  }) {
    return Notification(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.id == id &&
        other.title == title &&
        other.message == message &&
        other.timestamp == timestamp &&
        other.read == read;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      message.hashCode ^
      timestamp.hashCode ^
      read.hashCode;

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, message: $message, timestamp: $timestamp, read: $read)';
  }
} 