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
//   final String specialty = 'Dermatologist'; // Added specialty field
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
//
//   // Add toMap method for saving to Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'location': location,
//       'description': description,
//       'imageAsset': imageAsset,
//       'rating': rating,
//       'email': email,
//       'workingDays': workingDays,
//       'startTime': '${startTime.hour}:${startTime.minute}',
//       'endTime': '${endTime.hour}:${endTime.minute}',
//       'isActive': true,
//       'specialty': specialty,
//     };
//   }
// }

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
//   final String? phoneNumber; // Added phone number
//   final List<String> workingDays;
//   final TimeOfDay startTime;
//   final TimeOfDay endTime;
//   final String specialty;
//   final bool isActive;
//   final List<String> qualifications; // Added qualifications
//   final int experienceYears; // Added experience
//   final double consultationFee; // Added consultation fee
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Dermatologist({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageAsset,
//     required this.rating,
//     required this.email,
//     this.phoneNumber,
//     required this.workingDays,
//     required this.startTime,
//     required this.endTime,
//     this.specialty = 'Dermatologist',
//     this.isActive = true,
//     this.qualifications = const [],
//     this.experienceYears = 0,
//     this.consultationFee = 0.0,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) : createdAt = createdAt ?? DateTime.now(),
//         updatedAt = updatedAt ?? DateTime.now();
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
//       phoneNumber: map['phoneNumber'] as String?,
//       workingDays: List<String>.from(map['workingDays'] as List? ?? []),
//       startTime: TimeOfDay(
//         hour: int.tryParse(startTimeParts[0]) ?? 9,
//         minute: int.tryParse(startTimeParts.length > 1 ? startTimeParts[1] : '0') ?? 0,
//       ),
//       endTime: TimeOfDay(
//         hour: int.tryParse(endTimeParts[0]) ?? 17,
//         minute: int.tryParse(endTimeParts.length > 1 ? endTimeParts[1] : '0') ?? 0,
//       ),
//       specialty: map['specialty'] as String? ?? 'Dermatologist',
//       isActive: map['isActive'] as bool? ?? true,
//       qualifications: List<String>.from(map['qualifications'] as List? ?? []),
//       experienceYears: map['experienceYears'] as int? ?? 0,
//       consultationFee: (map['consultationFee'] as num?)?.toDouble() ?? 0.0,
//       createdAt: map['createdAt'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
//           : DateTime.now(),
//       updatedAt: map['updatedAt'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
//           : DateTime.now(),
//     );
//   }
//
//   // Enhanced toMap method
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'location': location,
//       'description': description,
//       'imageAsset': imageAsset,
//       'rating': rating,
//       'email': email,
//       'phoneNumber': phoneNumber,
//       'workingDays': workingDays,
//       'startTime': _formatTime(startTime),
//       'endTime': _formatTime(endTime),
//       'specialty': specialty,
//       'isActive': isActive,
//       'qualifications': qualifications,
//       'experienceYears': experienceYears,
//       'consultationFee': consultationFee,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'updatedAt': updatedAt.millisecondsSinceEpoch,
//     };
//   }
//
//   // Helper method for consistent time formatting
//   String _formatTime(TimeOfDay time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }
//
//   // Utility methods
//   bool isAvailableToday() {
//     final today = DateTime.now();
//     final dayName = _getDayName(today.weekday);
//     return workingDays.contains(dayName) && isActive;
//   }
//
//   bool isAvailableOn(DateTime date) {
//     final dayName = _getDayName(date.weekday);
//     return workingDays.contains(dayName) && isActive;
//   }
//
//   String _getDayName(int weekday) {
//     const days = [
//       'Monday', 'Tuesday', 'Wednesday', 'Thursday',
//       'Friday', 'Saturday', 'Sunday'
//     ];
//     return days[weekday - 1];
//   }
//
//   String get formattedWorkingHours {
//     return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
//   }
//
//   String get workingDaysFormatted {
//     if (workingDays.isEmpty) return 'No working days specified';
//     if (workingDays.length == 7) return 'Every day';
//     if (workingDays.length == 5 &&
//         !workingDays.contains('Saturday') &&
//         !workingDays.contains('Sunday')) {
//       return 'Weekdays';
//     }
//     return workingDays.join(', ');
//   }
//
//   // Copy with method for immutability
//   Dermatologist copyWith({
//     String? id,
//     String? name,
//     String? location,
//     String? description,
//     String? imageAsset,
//     double? rating,
//     String? email,
//     String? phoneNumber,
//     List<String>? workingDays,
//     TimeOfDay? startTime,
//     TimeOfDay? endTime,
//     String? specialty,
//     bool? isActive,
//     List<String>? qualifications,
//     int? experienceYears,
//     double? consultationFee,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return Dermatologist(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       location: location ?? this.location,
//       description: description ?? this.description,
//       imageAsset: imageAsset ?? this.imageAsset,
//       rating: rating ?? this.rating,
//       email: email ?? this.email,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       workingDays: workingDays ?? this.workingDays,
//       startTime: startTime ?? this.startTime,
//       endTime: endTime ?? this.endTime,
//       specialty: specialty ?? this.specialty,
//       isActive: isActive ?? this.isActive,
//       qualifications: qualifications ?? this.qualifications,
//       experienceYears: experienceYears ?? this.experienceYears,
//       consultationFee: consultationFee ?? this.consultationFee,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? DateTime.now(),
//     );
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is Dermatologist && other.id == id;
//   }
//
//   @override
//   int get hashCode => id.hashCode;
//
//   @override
//   String toString() {
//     return 'Dermatologist(id: $id, name: $name, specialty: $specialty, rating: $rating)';
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dermatologist {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageAsset;
  final double rating;
  final String email;
  final String? phoneNumber; // Added phone number
  final List<String> workingDays;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String specialty;
  final bool isActive;
  final List<String> qualifications; // Added qualifications
  final int experienceYears; // Added experience
  final double consultationFee; // Added consultation fee

  Dermatologist({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageAsset,
    required this.rating,
    required this.email,
    this.phoneNumber,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    this.specialty = 'Dermatologist',
    this.isActive = true,
    this.qualifications = const [],
    this.experienceYears = 0,
    this.consultationFee = 0.0,
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
      phoneNumber: map['phoneNumber'] as String?,
      workingDays: List<String>.from(map['workingDays'] as List? ?? []),
      startTime: TimeOfDay(
        hour: int.tryParse(startTimeParts[0]) ?? 9,
        minute: int.tryParse(startTimeParts.length > 1 ? startTimeParts[1] : '0') ?? 0,
      ),
      endTime: TimeOfDay(
        hour: int.tryParse(endTimeParts[0]) ?? 17,
        minute: int.tryParse(endTimeParts.length > 1 ? endTimeParts[1] : '0') ?? 0,
      ),
      specialty: map['specialty'] as String? ?? 'Dermatologist',
      isActive: map['isActive'] as bool? ?? true,
      qualifications: List<String>.from(map['qualifications'] as List? ?? []),
      experienceYears: map['experienceYears'] as int? ?? 0,
      consultationFee: (map['consultationFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Enhanced toMap method
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'imageAsset': imageAsset,
      'rating': rating,
      'email': email,
      'phoneNumber': phoneNumber,
      'workingDays': workingDays,
      'startTime': _formatTime(startTime),
      'endTime': _formatTime(endTime),
      'specialty': specialty,
      'isActive': isActive,
      'qualifications': qualifications,
      'experienceYears': experienceYears,
      'consultationFee': consultationFee,
    };
  }

  // Helper method for consistent time formatting
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Utility methods
  bool isAvailableToday() {
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);
    return workingDays.contains(dayName) && isActive;
  }

  bool isAvailableOn(DateTime date) {
    final dayName = _getDayName(date.weekday);
    return workingDays.contains(dayName) && isActive;
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }

  String get formattedWorkingHours {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String get workingDaysFormatted {
    if (workingDays.isEmpty) return 'No working days specified';
    if (workingDays.length == 7) return 'Every day';
    if (workingDays.length == 5 &&
        !workingDays.contains('Saturday') &&
        !workingDays.contains('Sunday')) {
      return 'Weekdays';
    }
    return workingDays.join(', ');
  }

  // Copy with method for immutability
  Dermatologist copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    String? imageAsset,
    double? rating,
    String? email,
    String? phoneNumber,
    List<String>? workingDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? specialty,
    bool? isActive,
    List<String>? qualifications,
    int? experienceYears,
    double? consultationFee,
  }) {
    return Dermatologist(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      rating: rating ?? this.rating,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      specialty: specialty ?? this.specialty,
      isActive: isActive ?? this.isActive,
      qualifications: qualifications ?? this.qualifications,
      experienceYears: experienceYears ?? this.experienceYears,
      consultationFee: consultationFee ?? this.consultationFee,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dermatologist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Dermatologist(id: $id, name: $name, specialty: $specialty, rating: $rating)';
  }
}
