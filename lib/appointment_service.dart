// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'appointment_model.dart';
// import 'dermatologist_model.dart';
//
// class AppointmentService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Book an appointment
//   Future<void> bookAppointment(Appointment appointment) async {
//     try {
//       await _firestore
//           .collection('appointments')
//           .doc(appointment.id)
//           .set(appointment.toMap());
//     } catch (e) {
//       throw Exception('Failed to book appointment: $e');
//     }
//   }
//
//   // Get available time slots for a dermatologist on a specific date
//   Future<List<TimeOfDay>> getAvailableTimeSlots(
//       String dermatologistId,
//       DateTime date,
//       TimeOfDay startTime,
//       TimeOfDay endTime,
//       ) async {
//     try {
//       // Get existing appointments for the date
//       final existingAppointments = await _firestore
//           .collection('appointments')
//           .where('dermatologistId', isEqualTo: dermatologistId)
//           .where('date', isEqualTo: Timestamp.fromDate(date))
//           .where('status', whereIn: ['pending', 'confirmed'])
//           .get();
//
//       // Extract booked time slots
//       List<TimeOfDay> bookedSlots = existingAppointments.docs
//           .map((doc) {
//         final data = doc.data();
//         final timeMap = data['time'] as Map<String, dynamic>;
//         return TimeOfDay(
//           hour: timeMap['hour'] as int,
//           minute: timeMap['minute'] as int,
//         );
//       })
//           .toList();
//
//       // Generate all possible time slots (30-minute intervals)
//       List<TimeOfDay> allSlots = [];
//       int startMinutes = startTime.hour * 60 + startTime.minute;
//       int endMinutes = endTime.hour * 60 + endTime.minute;
//
//       for (int minutes = startMinutes; minutes < endMinutes; minutes += 30) {
//         allSlots.add(TimeOfDay(
//           hour: minutes ~/ 60,
//           minute: minutes % 60,
//         ));
//       }
//
//       // Filter out booked slots
//       List<TimeOfDay> availableSlots = allSlots.where((slot) {
//         return !bookedSlots.any((bookedSlot) =>
//         bookedSlot.hour == slot.hour && bookedSlot.minute == slot.minute);
//       }).toList();
//
//       return availableSlots;
//     } catch (e) {
//       throw Exception('Failed to get available time slots: $e');
//     }
//   }
//
//   // Send appointment request to dermatologist
//   Future<void> sendAppointmentRequest({
//     required Appointment appointment,
//     required Dermatologist dermatologist,
//     required String userEmail,
//     required String userName,
//   }) async {
//     try {
//       final url = Uri.parse('https://your-api-endpoint/send-email');
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'type': 'dermatologist_request',
//           'dermatologist_email': dermatologist.email,
//           'appointment_id': appointment.id,
//           'user_name': userName,
//           'user_email': userEmail,
//           'date': DateFormat('yyyy-MM-dd').format(appointment.date),
//           'time': _formatTimeOfDay(appointment.time),
//           'dermatologist_name': dermatologist.name,
//           'user_phone': appointment.userPhone,
//         }),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to send appointment request: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to send appointment request: $e');
//     }
//   }
//
//   // Send confirmation email to user
//   Future<void> sendConfirmationEmail({
//     required Appointment appointment,
//     required Dermatologist dermatologist,
//   }) async {
//     try {
//       final url = Uri.parse('https://your-api-endpoint/send-email');
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'type': 'appointment_confirmation',
//           'user_email': appointment.userEmail,
//           'user_name': appointment.userName,
//           'appointment_id': appointment.id,
//           'dermatologist_name': dermatologist.name,
//           'dermatologist_email': dermatologist.email,
//           'date': DateFormat('yyyy-MM-dd').format(appointment.date),
//           'time': _formatTimeOfDay(appointment.time),
//           'contact_info': appointment.contactInfo ?? dermatologist.phoneNumber,
//         }),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to send confirmation email: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to send confirmation email: $e');
//     }
//   }
//
//   // Send cancellation email to user
//   Future<void> sendCancellationEmail({
//     required Appointment appointment,
//     required Dermatologist dermatologist,
//     required String cancelReason,
//   }) async {
//     try {
//       final url = Uri.parse('https://your-api-endpoint/send-email');
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'type': 'appointment_cancellation',
//           'user_email': appointment.userEmail,
//           'user_name': appointment.userName,
//           'appointment_id': appointment.id,
//           'dermatologist_name': dermatologist.name,
//           'date': DateFormat('yyyy-MM-dd').format(appointment.date),
//           'time': _formatTimeOfDay(appointment.time),
//           'cancel_reason': cancelReason,
//         }),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to send cancellation email: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to send cancellation email: $e');
//     }
//   }
//
//   // Send reminder email to user (24 hours before appointment)
//   Future<void> sendReminderEmail({
//     required Appointment appointment,
//     required Dermatologist dermatologist,
//   }) async {
//     try {
//       final url = Uri.parse('https://your-api-endpoint/send-email');
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'type': 'appointment_reminder',
//           'user_email': appointment.userEmail,
//           'user_name': appointment.userName,
//           'appointment_id': appointment.id,
//           'dermatologist_name': dermatologist.name,
//           'dermatologist_email': dermatologist.email,
//           'date': DateFormat('yyyy-MM-dd').format(appointment.date),
//           'time': _formatTimeOfDay(appointment.time),
//           'contact_info': appointment.contactInfo ?? dermatologist.phoneNumber,
//         }),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to send reminder email: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to send reminder email: $e');
//     }
//   }
//
//   // Update appointment status
//   Future<void> updateAppointmentStatus(String appointmentId, String status) async {
//     try {
//       await _firestore
//           .collection('appointments')
//           .doc(appointmentId)
//           .update({'status': status});
//     } catch (e) {
//       throw Exception('Failed to update appointment status: $e');
//     }
//   }
//
//   // Cancel appointment
//   Future<void> cancelAppointment(String appointmentId, String cancelReason) async {
//     try {
//       await _firestore
//           .collection('appointments')
//           .doc(appointmentId)
//           .update({
//         'status': 'cancelled',
//         'cancelReason': cancelReason,
//       });
//     } catch (e) {
//       throw Exception('Failed to cancel appointment: $e');
//     }
//   }
//
//   // Get appointments by user ID
//   Future<List<Appointment>> getUserAppointments(String userId) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('appointments')
//           .where('userId', isEqualTo: userId)
//           .orderBy('date', descending: false)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => Appointment.fromMap(doc.data()))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get user appointments: $e');
//     }
//   }
//
//   // Get appointments by dermatologist ID
//   Future<List<Appointment>> getDermatologistAppointments(String dermatologistId) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('appointments')
//           .where('dermatologistId', isEqualTo: dermatologistId)
//           .orderBy('date', descending: false)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => Appointment.fromMap(doc.data()))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get dermatologist appointments: $e');
//     }
//   }
//
//   // Get single appointment by ID
//   Future<Appointment?> getAppointmentById(String appointmentId) async {
//     try {
//       final doc = await _firestore
//           .collection('appointments')
//           .doc(appointmentId)
//           .get();
//
//       if (doc.exists) {
//         return Appointment.fromMap(doc.data()!);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to get appointment: $e');
//     }
//   }
//
//   // Helper method to format TimeOfDay
//   String _formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
//
//   // Complete appointment booking process
//   Future<void> completeAppointmentBooking({
//     required Appointment appointment,
//     required Dermatologist dermatologist,
//   }) async {
//     try {
//       // 1. Book the appointment
//       await bookAppointment(appointment);
//
//       // 2. Send request to dermatologist
//       await sendAppointmentRequest(
//         appointment: appointment,
//         dermatologist: dermatologist,
//         userEmail: appointment.userEmail,
//         userName: appointment.userName,
//       );
//     } catch (e) {
//       throw Exception('Failed to complete appointment booking: $e');
//     }
//   }
//
//   // Complete appointment confirmation process
//   Future<void> completeAppointmentConfirmation({
//     required String appointmentId,
//     required Dermatologist dermatologist,
//   }) async {
//     try {
//       // 1. Update appointment status
//       await updateAppointmentStatus(appointmentId, 'confirmed');
//
//       // 2. Get updated appointment
//       final appointment = await getAppointmentById(appointmentId);
//       if (appointment != null) {
//         // 3. Send confirmation email to user
//         await sendConfirmationEmail(
//           appointment: appointment,
//           dermatologist: dermatologist,
//         );
//       }
//     } catch (e) {
//       throw Exception('Failed to complete appointment confirmation: $e');
//     }
//   }
//
//   // Complete appointment cancellation process
//   Future<void> completeAppointmentCancellation({
//     required String appointmentId,
//     required String cancelReason,
//     required Dermatologist dermatologist,
//   }) async {
//     try {
//       // 1. Get appointment before cancellation
//       final appointment = await getAppointmentById(appointmentId);
//       if (appointment != null) {
//         // 2. Cancel the appointment
//         await cancelAppointment(appointmentId, cancelReason);
//
//         // 3. Send cancellation email to user
//         await sendCancellationEmail(
//           appointment: appointment,
//           dermatologist: dermatologist,
//           cancelReason: cancelReason,
//         );
//       }
//     } catch (e) {
//       throw Exception('Failed to complete appointment cancellation: $e');
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'appointment_model.dart';
// import 'dermatologist_model.dart';
//
// class AppointmentService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> bookAppointment(Appointment appointment) async {
//     try {
//       // Add appointment to the 'appointments' collection
//       await _firestore.collection('appointments').doc(appointment.id).set({
//         'id': appointment.id,
//         'userId': appointment.userId,
//         'dermatologistId': appointment.dermatologistId,
//         'dermatologistEmail': appointment.dermatologistEmail,
//         'date': Timestamp.fromDate(appointment.date),
//         'time': {
//           'hour': appointment.time.hour,
//           'minute': appointment.time.minute,
//         },
//         'status': appointment.status,
//         'userName': appointment.userName,
//         'userEmail': appointment.userEmail,
//         'userPhone': appointment.userPhone,
//         'dermatologistName': appointment.dermatologistName,
//         'createdAt': Timestamp.fromDate(appointment.createdAt),
//         'consultationFee': appointment.consultationFee,
//       });
//     } catch (e) {
//       throw Exception('Failed to book appointment: $e');
//     }
//   }
//
//   Future<void> sendAppointmentRequest({
//     required Appointment appointment,
//     required Dermatologist dermatologist,
//     required String userEmail,
//     required String userName,
//   }) async {
//     try {
//       // You can add additional logic here to send notifications/emails
//       // For now, we'll just log it
//       debugPrint('Appointment request sent to ${dermatologist.name}');
//     } catch (e) {
//       throw Exception('Failed to send appointment request: $e');
//     }
//   }
//
// // Add other Firestore operations as needed



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'appointment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Automatic document creation
  Future<void> bookAppointment(Appointment appointment) async {
    try {
      debugPrint('Starting booking process...');
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');
      debugPrint('User UID: ${user.uid}');

      // Fetch user details from 'users' collection
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      debugPrint('User document exists: ${userDoc.exists}');
      if (!userDoc.exists) throw Exception('User document not found');

      final userData = userDoc.data()!;

      // Map your specific field names
      // final userEmail = userData['email'] ?? user.email ?? '';
      // final userPhone = userData['phoneNumber'] ?? '';
      // final userName = userData['username'] ?? '';

      // Verify we have all required fields
      final userEmail = userData['email']?.toString() ?? '';
      final userPhone = userData['phoneNumber']?.toString() ?? '';
      final userName = userData['username']?.toString() ?? '';

      debugPrint('''
      Extracted user details:
      Email: $userEmail
      Phone: $userPhone
      Username: $userName
      ''');

      // Validate required fields
      if (userEmail.isEmpty) throw Exception('User email missing');
      // if (userPhone.isEmpty) throw Exception('User phone missing');
      if (userName.isEmpty) throw Exception('Username missing');

      // Create complete appointment with user details
      final completeAppointment = appointment.copyWith(
        userId: user.uid,
        userEmail: userEmail,
        userPhone: userPhone,
        userName: userName,
      );

      debugPrint('Complete appointment: ${completeAppointment.toFirestore()}');

      // This will automatically create the collection/document if they don't exist
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(completeAppointment.toFirestore());
      debugPrint('Appointment successfully written to Firestore');
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      throw Exception('Failed to book appointment: $e');
    }
  }

  // Get appointments for a specific user
  Stream<List<Appointment>> getUserAppointments(String userId) {
    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Appointment.fromFirestore(doc))
        .toList());
  }

  // Optional: Check for existing appointments at the same time
  Future<bool> isSlotAvailable(
      String dermatologistId, DateTime date, TimeOfDay time) async {
    try {
      // Convert DateTime to just date (without time)
      final appointmentDate = DateTime(date.year, date.month, date.day);

      final snapshot = await _firestore
          .collection('appointments')
          .where('dermatologistId', isEqualTo: dermatologistId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();

      final hour = time.hour;
      final minute = time.minute;

      return !snapshot.docs.any((doc) {
        final data = doc.data();
        return data['time']['hour'] == hour && data['time']['minute'] == minute;
      });
    }catch (e) {
      debugPrint('Error checking slot availability: $e');
      return false; // Assume slot is not available if there's an error
    }
  }

  Future<void> confirmAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'confirmed',
      'confirmedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'cancelled',
      'cancellationReason': reason,
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }

}