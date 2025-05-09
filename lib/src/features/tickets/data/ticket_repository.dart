import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/ticket_model.dart';

// Provider cho ticket repository
final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return TicketRepository(FirebaseFirestore.instance);
});

// Provider để theo dõi vé của người dùng
final userTicketsStreamProvider = StreamProvider.family<List<Ticket>, String>((ref, userId) {
  final repository = ref.watch(ticketRepositoryProvider);
  return repository.watchUserTickets(userId);
});

class TicketRepository {
  final FirebaseFirestore _firestore;
  
  TicketRepository(this._firestore);
  
  // Collection reference
  CollectionReference<Map<String, dynamic>> get ticketsRef => 
      _firestore.collection('tickets');
  
  // Lấy stream vé của người dùng
  Stream<List<Ticket>> watchUserTickets(String userId) {
    return ticketsRef
        .where('userId', isEqualTo: userId)
        .orderBy('tripDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Ticket.fromMap(doc.data(), doc.id))
            .toList());
  }
  
  // Đặt vé mới với error handling
  Future<bool> bookTicket({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String pickupPoint,
    required String destinationPoint,
    required String tripCode,
    required DateTime tripDate,
  }) async {
    try {
      // Kiểm tra dữ liệu đầu vào
      if (userId.isEmpty || fullName.isEmpty || phoneNumber.isEmpty ||
          pickupPoint.isEmpty || destinationPoint.isEmpty || tripCode.isEmpty) {
        throw Exception('Dữ liệu đầu vào không hợp lệ');
      }
      
      // Tạo vé mới
      final ticket = Ticket(
        id: '', // Sẽ được tạo bởi Firestore
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        pickupPoint: pickupPoint,
        destinationPoint: destinationPoint,
        tripCode: tripCode,
        tripDate: tripDate,
        bookingTime: DateTime.now(),
        status: 'confirmed',
      );
      
      // Lưu vé vào Firestore với timeout
      final docRef = await ticketsRef.add(ticket.toMap())
        .timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception('Timeout khi kết nối đến máy chủ');
        });
      
      return docRef.id.isNotEmpty;
    } on FirebaseException catch (e) {
      print('Firebase error booking ticket: ${e.code} - ${e.message}');
      if (e.code == 'permission-denied') {
        throw Exception('Không có quyền thực hiện thao tác này');
      } else if (e.code == 'unavailable') {
        throw Exception('Không thể kết nối đến máy chủ, vui lòng thử lại sau');
      }
      throw Exception('Lỗi Firebase: ${e.message}');
    } catch (e) {
      // Ghi log lỗi (trong ứng dụng thực tế có thể gửi lỗi tới service)
      print('Error booking ticket: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đã xảy ra lỗi không xác định');
    }
  }
  
  // Lấy vé theo ID
  Future<Ticket?> getTicketById(String ticketId) async {
    try {
      final docSnapshot = await ticketsRef.doc(ticketId).get();
      if (docSnapshot.exists) {
        return Ticket.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting ticket: $e');
      return null;
    }
  }
  
  // Hủy vé
  Future<bool> cancelTicket(String ticketId) async {
    try {
      await ticketsRef.doc(ticketId).update({'status': 'cancelled'});
      return true;
    } catch (e) {
      print('Error cancelling ticket: $e');
      return false;
    }
  }
  
  // Lấy danh sách vé của người dùng
  Future<List<Ticket>> fetchUserTickets(String userId) async {
    try {
      final snapshot = await ticketsRef
          .where('userId', isEqualTo: userId)
          .orderBy('tripDate', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Ticket.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching user tickets: $e');
      return [];
    }
  }
} 