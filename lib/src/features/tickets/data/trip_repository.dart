import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/features/tickets/domain/ticket_model.dart';
import '../domain/trip_model.dart';

// Provider cho trip repository
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepository(FirebaseFirestore.instance);
});

// Provider để lấy chuyến xe theo tuyến
final tripsByRouteProvider =
    FutureProvider.family<List<Trip>, (String, String, DateTime)>(
        (ref, params) {
  final repository = ref.watch(tripRepositoryProvider);
  final (origin, destination, selectedDate) = params;
  return repository.getTripsByRoute(origin, destination, selectedDate);
});

// Provider để lấy danh sách chuyến xe
final tripsProvider = FutureProvider<List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getAllActiveTrips();
});

// Provider để lấy chi tiết chuyến xe theo ID
final tripProvider = FutureProvider.family<Trip?, String>((ref, tripId) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTripById(tripId);
});

class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository(this._firestore);

  // Collection reference
  CollectionReference<Map<String, dynamic>> get tripsRef =>
      _firestore.collection('trips');

  CollectionReference<Map<String, dynamic>> get ticketsRef =>
      _firestore.collection('tickets');

  // Lấy danh sách chuyến xe theo tuyến đường
  Future<List<Trip>> getTripsByRoute(
      String origin, String destination, DateTime selectedDate) async {
    try {
      // Tìm chuyến theo cả điểm đi và điểm đến
      final snapshot = await tripsRef
          .where('origin', isEqualTo: origin)
          .where('destination', isEqualTo: destination)
          .where('isActive', isEqualTo: true)
          .get();

      final startOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ); // ví dụ: 2025-05-13 00:00:00

      final endOfDay = startOfDay.add(Duration(days: 1));

      final startTimestamp = Timestamp.fromDate(startOfDay);
      final endTimestamp = Timestamp.fromDate(endOfDay);

      final ticketSnapshot = await ticketsRef
          .where('tripDate', isGreaterThanOrEqualTo: startTimestamp)
          .where('tripDate', isLessThan: endTimestamp)
          .get();

      var list =
          snapshot.docs.map((doc) => Trip.fromMap(doc.data(), doc.id)).toList();

      var ticketList = ticketSnapshot.docs
          .map((doc) => Ticket.fromMap(doc.data(), doc.id))
          .toList();

      final Map<String, int> counts = {};
      for (var t in ticketList) {
        counts[t.tripCode] = (counts[t.tripCode] ?? 0) + 1;
      }

      final updatedList = list.map((trip) {
        if (counts.containsKey(trip.code)) {
          return trip.copyWith(
              availableSeats: trip.availableSeats - counts[trip.code]!);
        }
        return trip;
      }).toList();

      return updatedList;
    } catch (e) {
      print('Error getting trips by route: $e');
      return [];
    }
  }

  // Lấy chuyến xe theo ID
  Future<Trip?> getTripById(String tripId) async {
    try {
      final docSnapshot = await tripsRef.doc(tripId).get();
      if (docSnapshot.exists) {
        return Trip.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting trip by ID: $e');
      return null;
    }
  }

  // Cập nhật số ghế còn trống của chuyến xe
  Future<bool> updateTripAvailableSeats(
      {required String tripId, required int availableSeats}) async {
    try {
      // Đảm bảo số ghế không âm
      final updatedSeats = availableSeats < 0 ? 0 : availableSeats;

      // Sử dụng transaction để tránh race condition
      await _firestore.runTransaction((transaction) async {
        final tripDoc = tripsRef.doc(tripId);
        final tripSnapshot = await transaction.get(tripDoc);

        if (!tripSnapshot.exists) {
          throw Exception('Không tìm thấy chuyến xe');
        }

        transaction.update(tripDoc, {'availableSeats': updatedSeats});
      });

      return true;
    } catch (e) {
      print('Error updating trip seats: $e');
      return false;
    }
  }

  // Lấy tất cả các chuyến xe đang hoạt động
  Future<List<Trip>> getAllActiveTrips() async {
    try {
      final snapshot = await tripsRef.where('isActive', isEqualTo: true).get();

      return snapshot.docs
          .map((doc) => Trip.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting all active trips: $e');
      return [];
    }
  }
}
