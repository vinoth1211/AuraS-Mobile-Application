// // appointment_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class Appointment {
//   final String id;
//   final String userId;
//   final String dermatologistId;
//   final DateTime date;
//   final TimeOfDay time;
//   final String status; // 'pending', 'confirmed', 'canceled'
//   final String userName;
//   final String userEmail;
//   final String userPhone;
//   final String dermatologistName;
//
//   Appointment({
//     required this.id,
//     required this.userId,
//     required this.dermatologistId,
//     required this.date,
//     required this.time,
//     required this.status,
//     required this.userName,
//     required this.userEmail,
//     required this.userPhone,
//     required this.dermatologistName,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'dermatologistId': dermatologistId,
//       'date': Timestamp.fromDate(date),
//       'time': '${time.hour}:${time.minute}',
//       'status': status,
//       'userName': userName,
//       'userEmail': userEmail,
//       'userPhone': userPhone,
//       'dermatologistName': dermatologistName,
//       'createdAt': Timestamp.now(),
//     };
//   }
// }

// appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AppointmentStatus {
  confirmed,
  pending,
  completed,
  cancelled,
}

class Appointment {
  final String id;
  final String userId;
  final String dermatologistId;
  final DateTime date;
  final TimeOfDay time;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String userName;
  final String userEmail;
  final String userPhone;
  final String dermatologistName;
  final String? dermatologistContact; // WhatsApp, phone, etc.
  final String? meetingLink; // Google Meet, Zoom, etc.
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  Appointment({
    required this.id,
    required this.userId,
    required this.dermatologistId,
    required this.date,
    required this.time,
    required this.status,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.dermatologistName,
    this.dermatologistContact,
    this.meetingLink,
    DateTime? createdAt,
    this.confirmedAt,
    this.cancelledAt,
    this.cancellationReason,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'dermatologistId': dermatologistId,
      'date': Timestamp.fromDate(date),
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'status': status,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'dermatologistName': dermatologistName,
      'dermatologistContact': dermatologistContact,
      'meetingLink': meetingLink,
      'createdAt': Timestamp.fromDate(createdAt),
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'cancellationReason': cancellationReason,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map, String documentId) {
    final timeParts = (map['time'] as String).split(':');
    return Appointment(
      id: documentId,
      userId: map['userId'] ?? '',
      dermatologistId: map['dermatologistId'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      status: map['status'] ?? 'pending',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPhone: map['userPhone'] ?? '',
      dermatologistName: map['dermatologistName'] ?? '',
      dermatologistContact: map['dermatologistContact'],
      meetingLink: map['meetingLink'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      confirmedAt: (map['confirmedAt'] as Timestamp?)?.toDate(),
      cancelledAt: (map['cancelledAt'] as Timestamp?)?.toDate(),
      cancellationReason: map['cancellationReason'],
    );
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? dermatologistId,
    DateTime? date,
    TimeOfDay? time,
    String? status,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? dermatologistName,
    String? dermatologistContact,
    String? meetingLink,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dermatologistId: dermatologistId ?? this.dermatologistId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      dermatologistName: dermatologistName ?? this.dermatologistName,
      dermatologistContact: dermatologistContact ?? this.dermatologistContact,
      meetingLink: meetingLink ?? this.meetingLink,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}