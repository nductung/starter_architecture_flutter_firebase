import 'package:cloud_firestore/cloud_firestore.dart';

/// This file contains functions to initialize sample data for the bus booking app.
/// Call these functions once to seed the database with initial trip data.

/// Initialize sample trip data in Firestore
Future<void> initializeSampleTrips() async {
  final firestore = FirebaseFirestore.instance;
  final tripsCollection = firestore.collection('trips');
  
  // Check if trips collection already has data
  final existingTrips = await tripsCollection.limit(1).get();
  if (existingTrips.docs.isNotEmpty) {
    print('Trips data already exists. Not initializing sample data.');
    return;
  }
  
  // Sample trips data
  final trips = [
    // Thanh Hoa to Hanoi
    {
      'code': 'TH-HN-0600',
      'origin': 'Thanh Hoá',
      'destination': 'Hà Nội',
      'departureTime': '06:00',
      'availableSeats': 12,
      'price': 200000.0,
      'isActive': true,
    },
    {
      'code': 'TH-HN-1200',
      'origin': 'Thanh Hoá',
      'destination': 'Hà Nội',
      'departureTime': '12:00',
      'availableSeats': 12,
      'price': 200000.0,
      'isActive': true,
    },
    
    // Hanoi to Thanh Hoa
    {
      'code': 'HN-TH-1000',
      'origin': 'Hà Nội',
      'destination': 'Thanh Hoá',
      'departureTime': '10:00',
      'availableSeats': 12,
      'price': 200000.0,
      'isActive': true,
    },
    {
      'code': 'HN-TH-1600',
      'origin': 'Hà Nội',
      'destination': 'Thanh Hoá',
      'departureTime': '16:00',
      'availableSeats': 12,
      'price': 200000.0,
      'isActive': true,
    },
  ];
  
  // Add trips to Firestore
  for (final trip in trips) {
    await tripsCollection.add(trip);
  }
  
  print('Successfully initialized sample trips data!');
}

/// Call this function in a temporary widget or during development to initialize the database
void seedSampleData() async {
  try {
    await initializeSampleTrips();
    print('Sample data initialization complete.');
  } catch (e) {
    print('Error initializing sample data: $e');
  }
} 