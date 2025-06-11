// appointment_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'appointment_model.dart';
import 'dermatologist_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Book appointment and send notification email to dermatologist
  Future<String> bookAppointment(Appointment appointment) async {
    try {
      // Add appointment to Firestore
      final DocumentReference docRef = await _firestore
          .collection('appointments')
          .add(appointment.toMap());

      // Send email notification to dermatologist
      await _sendEmailNotification(
        appointmentId: docRef.id,
        type: 'new_appointment',
        appointment: appointment.copyWith(id: docRef.id),
      );

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  // Confirm appointment by dermatologist
  Future<void> confirmAppointment(
      String appointmentId,
      String dermatologistContact,
      String? meetingLink,
      ) async {
    try {
      final appointment = await getAppointmentById(appointmentId);

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'confirmed',
        'confirmedAt': FieldValue.serverTimestamp(),
        'dermatologistContact': dermatologistContact,
        'meetingLink': meetingLink,
      });

      // Send confirmation email to user
      await _sendEmailNotification(
        appointmentId: appointmentId,
        type: 'appointment_confirmed',
        appointment: appointment.copyWith(
          status: 'confirmed',
          dermatologistContact: dermatologistContact,
          meetingLink: meetingLink,
        ),
      );
    } catch (e) {
      throw Exception('Failed to confirm appointment: $e');
    }
  }

  // Cancel appointment
  Future<void> cancelAppointment(
      String appointmentId,
      String cancellationReason,
      bool cancelledByDoctor,
      ) async {
    try {
      final appointment = await getAppointmentById(appointmentId);

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancellationReason': cancellationReason,
      });

      // Send cancellation email to user
      await _sendEmailNotification(
        appointmentId: appointmentId,
        type: 'appointment_cancelled',
        appointment: appointment.copyWith(
          status: 'cancelled',
          cancellationReason: cancellationReason,
        ),
      );
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  // Get appointment by ID
  Future<Appointment> getAppointmentById(String appointmentId) async {
    try {
      final doc = await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!doc.exists) {
        throw Exception('Appointment not found');
      }

      return Appointment.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get appointment: $e');
    }
  }

  // Get user appointments
  Stream<List<Appointment>> getUserAppointments(String userId) {
    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get dermatologist appointments
  Stream<List<Appointment>> getDermatologistAppointments(String dermatologistId) {
    return _firestore
        .collection('appointments')
        .where('dermatologistId', isEqualTo: dermatologistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get available time slots for a specific date and dermatologist
  Future<List<TimeOfDay>> getAvailableTimeSlots(
      String dermatologistId,
      DateTime date,
      TimeOfDay startTime,
      TimeOfDay endTime,
      ) async {
    try {
      // Get booked appointments for the date
      final QuerySnapshot appointments = await _firestore
          .collection('appointments')
          .where('dermatologistId', isEqualTo: dermatologistId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      // Get booked time slots
      final List<TimeOfDay> bookedSlots = appointments.docs.map((doc) {
        final timeParts = (doc['time'] as String).split(':');
        return TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }).toList();

      // Generate all possible slots (30-minute intervals)
      final List<TimeOfDay> allSlots = _generateTimeSlots(
        startTime,
        endTime,
        const Duration(minutes: 30),
      );

      // Filter out booked slots
      final List<TimeOfDay> availableSlots = allSlots.where((slot) {
        return !bookedSlots.any((booked) =>
        booked.hour == slot.hour && booked.minute == slot.minute);
      }).toList();

      return availableSlots;
    } catch (e) {
      throw Exception('Failed to get available time slots: $e');
    }
  }

  // Generate time slots
  List<TimeOfDay> _generateTimeSlots(
      TimeOfDay start,
      TimeOfDay end,
      Duration interval,
      ) {
    List<TimeOfDay> slots = [];
    TimeOfDay current = start;

    while (current.hour < end.hour ||
        (current.hour == end.hour && current.minute < end.minute)) {
      slots.add(current);

      // Add interval
      int totalMinutes = current.hour * 60 + current.minute + interval.inMinutes;
      current = TimeOfDay(
        hour: totalMinutes ~/ 60,
        minute: totalMinutes % 60,
      );
    }

    return slots;
  }

  // Send email notification using Cloud Functions
  Future<void> _sendEmailNotification({
    required String appointmentId,
    required String type,
    required Appointment appointment,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('sendEmailNotification');

      await callable.call({
        'appointmentId': appointmentId,
        'type': type,
        'appointmentData': appointment.toMap(),
      });
    } catch (e) {
      print('Error sending email notification: $e');
      // Don't throw error here to avoid breaking the main flow
    }
  }
}