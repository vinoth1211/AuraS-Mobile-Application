import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String userId;
  final String dermatologistId;
  final String dermatologistEmail;
  final DateTime date;
  final TimeOfDay time;
  final String status;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String dermatologistName;
  final DateTime createdAt;
  final double consultationFee;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? dermatologistPhone;

  Appointment({
    required this.id,
    required this.userId,
    required this.dermatologistId,
    required this.dermatologistEmail,
    required this.date,
    required this.time,
    this.status = 'pending',
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.dermatologistName,
    required this.createdAt,
    required this.consultationFee,
    this.confirmedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.dermatologistPhone,
  });

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'dermatologistId': dermatologistId,
      'dermatologistEmail': dermatologistEmail,
      'date': Timestamp.fromDate(date),
      'time': {'hour': time.hour, 'minute': time.minute},
      'status': status,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'dermatologistName': dermatologistName,
      'createdAt': Timestamp.fromDate(createdAt),
      'consultationFee': consultationFee,
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'cancellationReason': cancellationReason,
      'dermatologistPhone': dermatologistPhone,
    };
  }

  // Create from Firestore document
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      userId: data['userId'] ?? '',
      dermatologistId: data['dermatologistId'] ?? '',
      dermatologistEmail: data['dermatologistEmail'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: data['time']['hour'] ?? 0,
        minute: data['time']['minute'] ?? 0,
      ),
      status: data['status'] ?? 'pending',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhone: data['userPhone'] ?? '',
      dermatologistName: data['dermatologistName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      consultationFee: (data['consultationFee'] ?? 0).toDouble(),
      confirmedAt: data['confirmedAt'] != null ? (data['confirmedAt'] as Timestamp).toDate() : null,
      cancelledAt: data['cancelledAt'] != null ? (data['cancelledAt'] as Timestamp).toDate() : null,
      cancellationReason: data['cancellationReason'],
      dermatologistPhone: data['dermatologistPhone'],
    );
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? dermatologistId,
    String? dermatologistEmail,
    DateTime? date,
    TimeOfDay? time,
    String? status,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? dermatologistName,
    DateTime? createdAt,
    double? consultationFee,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? dermatologistPhone,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dermatologistId: dermatologistId ?? this.dermatologistId,
      dermatologistEmail: dermatologistEmail ?? this.dermatologistEmail,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      dermatologistName: dermatologistName ?? this.dermatologistName,
      createdAt: createdAt ?? this.createdAt,
      consultationFee: consultationFee ?? this.consultationFee,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      dermatologistPhone: dermatologistPhone ?? this.dermatologistPhone,
    );
  }
}