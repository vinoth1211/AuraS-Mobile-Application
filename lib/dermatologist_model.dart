// import 'package:flutter/material.dart';
//
// class Dermatologist {
//   final String id;
//   final String name;
//   final String location;
//   final String description;
//   final String imageAsset;
//   final double rating;
//   final String email;
//   final List<String> workingDays;
//   final TimeOfDay startTime;
//   final TimeOfDay endTime;
//
//   Dermatologist({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageAsset,
//     required this.rating,
//     required this.email,
//     required this.workingDays,
//     required this.startTime,
//     required this.endTime,
//   });
//
//   factory Dermatologist.fromMap(String id, Map<String, dynamic> map) {
//     // Parse times with null safety
//     final startTimeStr = map['startTime'] as String? ?? '09:00';
//     final endTimeStr = map['endTime'] as String? ?? '17:00';
//
//     final startTimeParts = startTimeStr.split(':');
//     final endTimeParts = endTimeStr.split(':');
//
//     return Dermatologist(
//       id: id,
//       name: map['name'] as String? ?? 'No Name',
//       location: map['location'] as String? ?? 'No Location',
//       description: map['description'] as String? ?? 'No Description',
//       imageAsset: map['imageAsset'] as String? ?? 'assets/images/default_doctor.png',
//       rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
//       email: map['email'] as String? ?? '',
//       workingDays: List<String>.from(map['workingDays'] as List? ?? []),
//       startTime: TimeOfDay(
//         hour: int.tryParse(startTimeParts[0]) ?? 9,
//         minute: int.tryParse(startTimeParts.length > 1 ? startTimeParts[1] : '0') ?? 0,
//       ),
//       endTime: TimeOfDay(
//         hour: int.tryParse(endTimeParts[0]) ?? 17,
//         minute: int.tryParse(endTimeParts.length > 1 ? endTimeParts[1] : '0') ?? 0,
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';

class Dermatologist {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageAsset;
  final double rating;
  final String email;
  final List<String> workingDays;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String specialty = 'Dermatologist'; // Added specialty field

  Dermatologist({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageAsset,
    required this.rating,
    required this.email,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
  });

  factory Dermatologist.fromMap(String id, Map<String, dynamic> map) {
    // Parse times with null safety
    final startTimeStr = map['startTime'] as String? ?? '09:00';
    final endTimeStr = map['endTime'] as String? ?? '17:00';

    final startTimeParts = startTimeStr.split(':');
    final endTimeParts = endTimeStr.split(':');

    return Dermatologist(
      id: id,
      name: map['name'] as String? ?? 'No Name',
      location: map['location'] as String? ?? 'No Location',
      description: map['description'] as String? ?? 'No Description',
      imageAsset: map['imageAsset'] as String? ?? 'assets/images/default_doctor.png',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      email: map['email'] as String? ?? '',
      workingDays: List<String>.from(map['workingDays'] as List? ?? []),
      startTime: TimeOfDay(
        hour: int.tryParse(startTimeParts[0]) ?? 9,
        minute: int.tryParse(startTimeParts.length > 1 ? startTimeParts[1] : '0') ?? 0,
      ),
      endTime: TimeOfDay(
        hour: int.tryParse(endTimeParts[0]) ?? 17,
        minute: int.tryParse(endTimeParts.length > 1 ? endTimeParts[1] : '0') ?? 0,
      ),
    );
  }

  // Add toMap method for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'imageAsset': imageAsset,
      'rating': rating,
      'email': email,
      'workingDays': workingDays,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'isActive': true,
      'specialty': specialty,
    };
  }
}
