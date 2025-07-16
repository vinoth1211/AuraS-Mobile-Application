import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'appointment_model.dart'; // Import your appointment model

class EmailTemplates {
  static String doctorRequest(Appointment appointment, String baseUrl, BuildContext context) {
    return '''
      <h2>New Appointment Request</h2>
      <p>Patient: ${appointment.userName}</p>
      <p>Date: ${DateFormat('MMM dd, yyyy').format(appointment.date)}</p>
      <p>Time: ${appointment.time.format(context)}</p>
      <div>
        <a href="$baseUrl/confirm?appointmentId=${appointment.id}">
          Confirm Appointment
        </a>
        <a href="$baseUrl/cancel?appointmentId=${appointment.id}">
          Cancel Appointment
        </a>
      </div>
    ''';
  }

  static String userConfirmation(Appointment appointment, BuildContext context) {
    return '''
      <h2>Your Appointment Has Been Confirmed</h2>
      <p>With: ${appointment.dermatologistName}</p>
      <p>Date: ${DateFormat('MMM dd, yyyy').format(appointment.date)}</p>
      <p>Time: ${appointment.time.format(context)}</p>
      <p>Contact: ${appointment.dermatologistPhone ?? 'N/A'}</p>
    ''';
  }

  static String cancellationNotice(Appointment appointment, BuildContext context) {
    return '''
      <h2>Appointment Cancellation Notice</h2>
      <p>Your appointment with ${appointment.dermatologistName} has been cancelled.</p>
      <p>Original Date: ${DateFormat('MMM dd, yyyy').format(appointment.date)}</p>
      <p>Time: ${appointment.time.format(context)}</p>
      ${appointment.cancellationReason != null ?
    '<p>Reason: ${appointment.cancellationReason}</p>' : ''}
    ''';
  }
}