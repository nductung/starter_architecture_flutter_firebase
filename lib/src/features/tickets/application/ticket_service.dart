import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/ticket_repository.dart';
import '../data/trip_repository.dart';
import '../domain/trip_model.dart';
import 'package:intl/intl.dart';
import '../../notifications/data/notifications_repository.dart';

// Tạo provider cho ticket service
final ticketServiceProvider = Provider<TicketService>((ref) {
  final ticketRepository = ref.watch(ticketRepositoryProvider);
  final tripRepository = ref.watch(tripRepositoryProvider);
  final notificationsRepository = ref.watch(notificationsRepositoryProvider);
  return TicketService(
      ticketRepository, tripRepository, notificationsRepository);
});

class TicketService {
  final TicketRepository ticketRepository;
  final TripRepository tripRepository;
  final NotificationsRepository notificationsRepository;

  TicketService(
      this.ticketRepository, this.tripRepository, this.notificationsRepository);

  // Phương thức đặt vé với kiểm tra logic và xử lý lỗi
  Future<void> bookTicket({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String pickupPoint,
    required String destinationPoint,
    required String tripId,
    required DateTime tripDate,
  }) async {
    try {
      // Lấy thông tin chuyến xe từ ID
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        throw Exception('Không tìm thấy thông tin chuyến xe');
      }

      if (trip.availableSeats <= 0) {
        throw Exception('Chuyến xe đã hết chỗ, vui lòng chọn chuyến khác');
      }

      // Kiểm tra ngày đã qua chưa
      final now = DateTime.now();
      final tripTime = DateTime(
        tripDate.year,
        tripDate.month,
        tripDate.day,
        int.parse(trip.departureTime.split(':')[0]),
        int.parse(trip.departureTime.split(':')[1]),
      );

      if (tripTime.isBefore(now)) {
        throw Exception('Không thể đặt vé cho chuyến đã khởi hành');
      }

      // Đặt vé mới
      final success = await ticketRepository.bookTicket(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        pickupPoint: pickupPoint,
        destinationPoint: destinationPoint,
        tripCode: trip.code,
        tripDate: tripDate,
      );

      if (!success) {
        throw Exception('Đặt vé không thành công, vui lòng thử lại');
      }

      // Cập nhật số ghế còng trống trong chuyến xe
      // await tripRepository.updateTripAvailableSeats(
      //   tripId: tripId,
      //   availableSeats: trip.availableSeats - 1,
      // );

      // Tạo thông báo đặt vé thành công
      await _createBookingSuccessNotification(
        userId: userId,
        tripCode: trip.code,
        origin: trip.origin,
        destination: trip.destination,
        tripDate: tripDate,
        departureTime: trip.departureTime,
      );
    } on FirebaseException catch (e) {
      throw Exception('Lỗi hệ thống: ${e.message}');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  // Tạo thông báo đặt vé thành công
  Future<void> _createBookingSuccessNotification({
    required String userId,
    required String tripCode,
    required String origin,
    required String destination,
    required DateTime tripDate,
    required String departureTime,
  }) async {
    try {
      final formattedDate = DateFormat('dd/MM/yyyy').format(tripDate);
      final title = 'Đặt vé thành công';
      final message =
          'Bạn đã đặt vé chuyến $tripCode từ $origin đến $destination vào ngày $formattedDate, khởi hành lúc $departureTime.';

      await notificationsRepository.addNotification(
        uid: userId,
        title: title,
        message: message,
      );
    } catch (e) {
      // Log lỗi nhưng không throw exception để không ảnh hưởng việc đặt vé
      print('Lỗi khi tạo thông báo đặt vé: $e');
    }
  }

  // Kiểm tra hai ngày có cùng ngày không (bỏ qua giờ, phút, giây)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Cancel a ticket
  Future<void> cancelTicket(String ticketId) async {
    await ticketRepository.cancelTicket(ticketId);
  }
}
