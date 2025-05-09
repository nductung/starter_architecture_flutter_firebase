import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_sizes.dart';
import '../data/ticket_repository.dart';
import '../domain/ticket_model.dart';
import 'ticket_details_screen.dart';
import '../../../features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';

class MyTicketsScreen extends ConsumerWidget {
  const MyTicketsScreen({super.key});

  static const path = '/my-tickets';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy thông tin người dùng hiện tại từ Firebase Authentication
    final user = ref.watch(authRepositoryProvider).currentUser;

    // Nếu chưa đăng nhập, hiển thị màn hình yêu cầu đăng nhập
    if (user == null) {
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // IconButton(
                        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                        // const SizedBox(width: 8),
                        Text(
                          'Vé của tôi',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.login_rounded,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Vui lòng đăng nhập để xem vé',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              // Chuyển đến màn hình đăng nhập
                              Navigator.of(context).pushNamed('/sign-in');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Đăng nhập'),
                          ),
                        ],
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

    // Listen to user tickets stream for realtime updates with current user's ID
    final ticketsAsync = ref.watch(userTicketsStreamProvider(user.uid));

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
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                      // const SizedBox(width: 8),
                      Text(
                        'Vé của tôi',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                // Tickets container
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(userTicketsStreamProvider(user.uid));
                        },
                        child: ticketsAsync.when(
                          data: (tickets) {
                            if (tickets.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.confirmation_number_outlined,
                                      size: 96,
                                      color: Colors.indigo.withOpacity(0.7),
                                    ),
                                    gapH16,
                                    Text(
                                      'Bạn chưa có vé nào',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    gapH8,
                                    Text(
                                      'Hãy đặt vé để bắt đầu hành trình của bạn',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.grey[600],
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    gapH32,
                                    // ElevatedButton.icon(
                                    //   onPressed: () {
                                    //     // Navigate to home screen
                                    //     Navigator.of(context)
                                    //         .popUntil((route) => route.isFirst);
                                    //   },
                                    //   icon: const Icon(Icons.add),
                                    //   label: const Text('Đặt vé ngay'),
                                    //   style: ElevatedButton.styleFrom(
                                    //     padding: const EdgeInsets.symmetric(
                                    //       horizontal: 24,
                                    //       vertical: 12,
                                    //     ),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(16),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width -
                                          64 -
                                          32,
                                      child: FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                        },
                                        icon: const Icon(Icons.add),
                                        label: Text("Đặt vé ngay"),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }

                            // Group tickets by month
                            final groupedTickets = <String, List<Ticket>>{};
                            for (final ticket in tickets) {
                              final monthYear =
                                  DateFormat('MM/yyyy').format(ticket.tripDate);
                              if (!groupedTickets.containsKey(monthYear)) {
                                groupedTickets[monthYear] = [];
                              }
                              groupedTickets[monthYear]!.add(ticket);
                            }

                            final sortedMonths = groupedTickets.keys.toList()
                              ..sort((a, b) {
                                final partsA = a.split('/');
                                final partsB = b.split('/');
                                final dateA = DateTime(
                                    int.parse(partsA[1]), int.parse(partsA[0]));
                                final dateB = DateTime(
                                    int.parse(partsB[1]), int.parse(partsB[0]));
                                return dateB.compareTo(dateA); // Newest first
                              });

                            return ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                for (final month in sortedMonths) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 8, bottom: 16),
                                    child: Text(
                                      DateFormat('MMMM yyyy', 'vi_VN').format(
                                        DateTime(
                                          int.parse(month.split('/')[1]),
                                          int.parse(month.split('/')[0]),
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                    ),
                                  ),
                                  ...groupedTickets[month]!.map((ticket) =>
                                      ModernTicketCard(ticket: ticket)),
                                ],
                              ],
                            );
                          },
                          loading: () => const Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (error, stackTrace) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  gapH16,
                                  Text(
                                    'Đã xảy ra lỗi khi tải dữ liệu',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  gapH8,
                                  Text(
                                    error.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  gapH24,
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.invalidate(
                                          userTicketsStreamProvider(user.uid));
                                    },
                                    child: const Text('Thử lại'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
}

class ModernTicketCard extends StatelessWidget {
  const ModernTicketCard({
    super.key,
    required this.ticket,
  });

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final isCancelled = ticket.status == 'cancelled';
    final isPast = ticket.tripDate.isBefore(DateTime.now());

    // Define status color based on ticket status
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isCancelled) {
      statusColor = Colors.red;
      statusText = 'Đã hủy';
      statusIcon = Icons.cancel_outlined;
    } else if (isPast) {
      statusColor = Colors.grey;
      statusText = 'Đã hoàn thành';
      statusIcon = Icons.check_circle_outline;
    } else {
      statusColor = Colors.green;
      statusText = 'Đã xác nhận';
      statusIcon = Icons.check_circle_outline;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TicketDetailsScreen(ticket: ticket),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isCancelled
                ? Colors.red.withOpacity(0.2)
                : (isPast
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2)),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Ticket header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCancelled
                    ? Colors.red.withOpacity(0.05)
                    : (isPast
                        ? Colors.grey.withOpacity(0.05)
                        : Colors.green.withOpacity(0.05)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mã chuyến: ${ticket.tripCode}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(ticket.tripDate),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dotted line separator
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  40,
                  (index) => Expanded(
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.3),
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),

            // Ticket content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Route with bus icon
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_bus_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ticket.pickupPoint} → ${ticket.destinationPoint}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Điểm đón: ${ticket.pickupPoint}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Passenger info and booking time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hành khách',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ticket.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thời gian đặt vé',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('HH:mm - dd/MM/yyyy')
                                  .format(ticket.bookingTime),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                TicketDetailsScreen(ticket: ticket),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        isCancelled ? 'Chi tiết vé đã hủy' : 'Xem chi tiết vé',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
