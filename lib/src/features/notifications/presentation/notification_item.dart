import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/application/notifications_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/features/notifications/domain/notification.dart' as app;

class NotificationItem extends ConsumerWidget {
  const NotificationItem({
    required this.notification,
    this.onTap,
    super.key,
  });

  final app.Notification notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // Define icon based on notification type (you can customize this)
    IconData notificationIcon;
    Color iconColor;
    
    // Detect notification type based on content (example)
    final title = notification.title.toLowerCase();
    if (title.contains('xác nhận') || title.contains('đã đặt')) {
      notificationIcon = Icons.check_circle_outline;
      iconColor = Colors.green;
    } else if (title.contains('chuyến') || title.contains('hành trình')) {
      notificationIcon = Icons.directions_bus_outlined;
      iconColor = Colors.blue;
    } else if (title.contains('hủy') || title.contains('lỗi')) {
      notificationIcon = Icons.error_outline;
      iconColor = Colors.red;
    } else if (title.contains('khuyến mãi') || title.contains('giảm giá')) {
      notificationIcon = Icons.local_offer_outlined;
      iconColor = Colors.orange;
    } else {
      notificationIcon = Icons.notifications_outlined;
      iconColor = theme.colorScheme.primary;
    }
    
    return InkWell(
      onTap: () {
        if (!notification.read) {
          ref.read(markNotificationAsReadProvider(notification.id));
        }
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  notificationIcon,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(notification.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: notification.read ? Colors.grey[600] : Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      // Within an hour, show minutes ago
      final minutes = difference.inMinutes;
      return '$minutes phút trước';
    } else if (difference.inHours < 24) {
      // Within a day, show hours ago
      final hours = difference.inHours;
      return '$hours giờ trước';
    } else if (difference.inDays < 7) {
      // Within a week, show days ago
      final days = difference.inDays;
      return '$days ngày trước';
    } else {
      // Longer than a week, show full date
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
} 