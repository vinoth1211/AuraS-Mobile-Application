import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'appointment_model.dart';
import 'appointment_service.dart';

class MyAppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final appointmentService = AppointmentService();

    return Scaffold(
      appBar: AppBar(title: Text('My Appointments')),
      body: StreamBuilder<List<Appointment>>(
        stream: appointmentService.getUserAppointments(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data!;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return AppointmentCard(appointment: appointment);
            },
          );
        },
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(appointment.dermatologistName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('MMM dd, yyyy').format(appointment.date)),
            Text(appointment.time.format(context)),
            if (appointment.status == 'confirmed')
              Chip(
                label: Text('Confirmed'),
                backgroundColor: Colors.green[100],
              )
            else if (appointment.status == 'cancelled')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text('Cancelled'),
                    backgroundColor: Colors.red[100],
                  ),
                  if (appointment.cancellationReason != null)
                    Text('Reason: ${appointment.cancellationReason}'),
                ],
              )
            else
              Chip(
                label: Text('Pending'),
                backgroundColor: Colors.orange[100],
              ),
          ],
        ),
      ),
    );
  }
}