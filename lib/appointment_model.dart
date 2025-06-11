// appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String userId;
  final String dermatologistId;
  final DateTime date;
  final TimeOfDay time;
  final String status; // 'pending', 'confirmed', 'canceled'
  final String userName;
  final String userEmail;
  final String userPhone;
  final String dermatologistName;

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
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'dermatologistId': dermatologistId,
      'date': Timestamp.fromDate(date),
      'time': '${time.hour}:${time.minute}',
      'status': status,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'dermatologistName': dermatologistName,
      'createdAt': Timestamp.now(),
    };
  }
}