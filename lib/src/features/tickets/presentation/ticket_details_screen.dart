import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_sizes.dart';
import '../../../features/authentication/data/firebase_auth_repository.dart';
import '../application/ticket_service.dart';
import '../domain/ticket_model.dart';

class TicketDetailsScreen extends ConsumerWidget {
  const TicketDetailsScreen({
    super.key,
    required this.ticket,
  });

  final Ticket ticket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kiểm tra người dùng đăng nhập
    final user = ref.watch(authRepositoryProvider).currentUser;
    final bool isUserAuthorized = user != null && ticket.userId == user.uid;
    
    // Nếu người dùng không được phép xem vé này, hiển thị thông báo lỗi
    if (!isUserAuthorized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết vé'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  'Bạn không có quyền xem vé này',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vé này thuộc về người dùng khác hoặc bạn chưa đăng nhập.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    final bool isCancelled = ticket.status == 'cancelled';
    final bool isPast = ticket.tripDate.isBefore(DateTime.now());
    final bool canCancel = !isCancelled && !isPast;

    // Define status color based on ticket status
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (isCancelled) {
      statusColor = Colors.red;
      statusText = 'Vé đã bị hủy';
      statusIcon = Icons.cancel_outlined;
    } else if (isPast) {
      statusColor = Colors.grey;
      statusText = 'Chuyến đã hoàn thành';
      statusIcon = Icons.check_circle_outline;
    } else {
      statusColor = Colors.green;
      statusText = 'Vé đã được xác nhận';
      statusIcon = Icons.check_circle_outline;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Chi tiết vé',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Mã: ${ticket.tripCode}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Ticket status container
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            statusText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isCancelled
                                ? 'Vé này đã bị hủy và không thể sử dụng'
                                : (isPast
                                    ? 'Chuyến đi đã kết thúc'
                                    : 'Vé của bạn đã sẵn sàng để sử dụng'),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trip info section
                          _buildSectionTitle(context, 'Thông tin chuyến đi'),
                          const SizedBox(height: 16),
                          
                          // Trip date and time
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  context,
                                  icon: Icons.calendar_today_outlined,
                                  iconColor: Colors.blue,
                                  label: 'Ngày đi',
                                  value: DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(ticket.tripDate),
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  context,
                                  icon: Icons.directions_bus_outlined,
                                  iconColor: Colors.blue,
                                  label: 'Tuyến đường',
                                  value: '${ticket.pickupPoint} → ${ticket.destinationPoint}',
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Passenger info
                          _buildSectionTitle(context, 'Thông tin hành khách'),
                          const SizedBox(height: 16),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.purple.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  context,
                                  icon: Icons.person_outlined,
                                  iconColor: Colors.purple,
                                  label: 'Họ tên',
                                  value: ticket.fullName,
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  context,
                                  icon: Icons.phone_outlined,
                                  iconColor: Colors.purple,
                                  label: 'Số điện thoại',
                                  value: ticket.phoneNumber,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Booking info
                          _buildSectionTitle(context, 'Thông tin đặt vé'),
                          const SizedBox(height: 16),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: _buildInfoRow(
                              context,
                              icon: Icons.access_time_outlined,
                              iconColor: Colors.amber.shade700,
                              label: 'Thời gian đặt vé',
                              value: DateFormat('HH:mm - dd/MM/yyyy').format(ticket.bookingTime),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Payment info
                          _buildSectionTitle(context, 'Thông tin thanh toán'),
                          const SizedBox(height: 16),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.payment_outlined,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Thanh toán tại xe',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Vui lòng thanh toán khi lên xe',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Vui lòng mang theo giấy tờ tùy thân để đối chiếu thông tin khi lên xe.',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Bottom actions
                if (canCancel)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => _showCancelDialog(context, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Hủy vé'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Text _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }
  
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Xác nhận hủy vé'),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn hủy vé này không? Hành động này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Hủy vé'),
            ),
          ],
        );
      },
    );
    
    if (result == true) {
      try {
        final ticketService = ref.read(ticketServiceProvider);
        await ticketService.cancelTicket(ticket.id);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vé đã được hủy thành công'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Go back to previous screen
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 