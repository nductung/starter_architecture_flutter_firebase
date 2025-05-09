import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final String id;
  final String code;
  final String origin;
  final String destination;
  final String departureTime; // "06:00", "12:00", etc.
  final int availableSeats;
  final double price;
  final bool isActive;

  const Trip({
    required this.id,
    required this.code,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.price,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        origin,
        destination,
        departureTime,
        availableSeats,
        price,
        isActive,
      ];

  factory Trip.fromMap(Map<String, dynamic> map, String documentId) {
    return Trip(
      id: documentId,
      code: map['code'] as String,
      origin: map['origin'] as String,
      destination: map['destination'] as String,
      departureTime: map['departureTime'] as String,
      availableSeats: map['availableSeats'] as int,
      price: (map['price'] as num).toDouble(),
      isActive: map['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime,
      'availableSeats': availableSeats,
      'price': price,
      'isActive': isActive,
    };
  }

  Trip copyWith({
    String? id,
    String? code,
    String? origin,
    String? destination,
    String? departureTime,
    int? availableSeats,
    double? price,
    bool? isActive,
  }) {
    return Trip(
      id: id ?? this.id,
      code: code ?? this.code,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }
} 