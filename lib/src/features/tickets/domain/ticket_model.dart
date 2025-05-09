import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String pickupPoint;
  final String destinationPoint;
  final String tripCode;
  final DateTime tripDate;
  final DateTime bookingTime;
  final String status; // 'confirmed', 'cancelled', etc.

  const Ticket({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.pickupPoint,
    required this.destinationPoint,
    required this.tripCode,
    required this.tripDate,
    required this.bookingTime,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        phoneNumber,
        pickupPoint,
        destinationPoint,
        tripCode,
        tripDate,
        bookingTime,
        status,
      ];

  factory Ticket.fromMap(Map<String, dynamic> map, String documentId) {
    return Ticket(
      id: documentId,
      userId: map['userId'] as String,
      fullName: map['fullName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      pickupPoint: map['pickupPoint'] as String,
      destinationPoint: map['destinationPoint'] as String,
      tripCode: map['tripCode'] as String,
      tripDate: (map['tripDate'] as Timestamp).toDate(),
      bookingTime: (map['bookingTime'] as Timestamp).toDate(),
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pickupPoint': pickupPoint,
      'destinationPoint': destinationPoint,
      'tripCode': tripCode,
      'tripDate': Timestamp.fromDate(tripDate),
      'bookingTime': Timestamp.fromDate(bookingTime),
      'status': status,
    };
  }

  Ticket copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? pickupPoint,
    String? destinationPoint,
    String? tripCode,
    DateTime? tripDate,
    DateTime? bookingTime,
    String? status,
  }) {
    return Ticket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      destinationPoint: destinationPoint ?? this.destinationPoint,
      tripCode: tripCode ?? this.tripCode,
      tripDate: tripDate ?? this.tripDate,
      bookingTime: bookingTime ?? this.bookingTime,
      status: status ?? this.status,
    );
  }
} 