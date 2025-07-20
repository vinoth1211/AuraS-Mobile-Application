import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'appointment_model.dart';
import 'appointment_service.dart';

class MyAppointmentsScreen extends StatefulWidget {
  @override
  _MyAppointmentsScreenState createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppointmentService _appointmentService = AppointmentService();
  final Color _primaryColor = const Color(0xFFDF4F5C);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _primaryColor,
          labelColor: _primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(userId, 'pending'),
          _buildAppointmentsList(userId, 'confirmed'),
          _buildAppointmentsList(userId, 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(String userId, String status) {
    return StreamBuilder<List<Appointment>>(
      stream: _appointmentService.getAppointmentsByStatus(userId, status),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading appointments',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return _buildEmptyState(status);
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return AppointmentCard(
                appointment: appointment,
                onTap: () => _showAppointmentDetails(appointment),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    String message;
    IconData icon;
    Color color;

    switch (status) {
      case 'pending':
        message = 'No pending appointments';
        icon = Icons.pending_actions;
        color = Colors.orange;
        break;
      case 'confirmed':
        message = 'No confirmed appointments';
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'cancelled':
        message = 'No cancelled appointments';
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      default:
        message = 'No appointments found';
        icon = Icons.event_note;
        color = Colors.grey;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: color.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your ${status.toLowerCase()} appointments will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentDetailsSheet(appointment: appointment),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    this.onTap,
  }) : super(key: key);

  // Helper method to format TimeOfDay
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Dr. ${appointment.dermatologistName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  _buildStatusBadge(appointment.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(appointment.date),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(appointment.time),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Rs. ${appointment.consultationFee.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'confirmed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentDetailsSheet extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsSheet({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  // Helper method to format TimeOfDay
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Appointment Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Doctor Info
                  _buildDetailRow(
                    icon: Icons.person,
                    label: 'Doctor',
                    value: 'Dr. ${appointment.dermatologistName}',
                  ),

                  // Doctor Email
                  _buildDetailRow(
                    icon: Icons.email,
                    label: 'Doctor Email',
                    value: appointment.dermatologistEmail,
                  ),

                  // Doctor Phone (if available)
                  if (appointment.dermatologistPhone != null)
                    _buildDetailRow(
                      icon: Icons.phone,
                      label: 'Doctor Phone',
                      value: appointment.dermatologistPhone!,
                    ),

                  // Date
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: DateFormat('EEEE, MMM dd, yyyy').format(appointment.date),
                  ),

                  // Time
                  _buildDetailRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: _formatTime(appointment.time),
                  ),

                  // Consultation Fee
                  _buildDetailRow(
                    icon: Icons.attach_money,
                    label: 'Consultation Fee',
                    value: 'Rs. ${appointment.consultationFee.toStringAsFixed(2)}',
                  ),

                  // Status
                  _buildDetailRow(
                    icon: Icons.info,
                    label: 'Status',
                    value: appointment.status.toUpperCase(),
                    valueColor: _getStatusColor(appointment.status),
                  ),

                  // Patient Info
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    label: 'Patient Name',
                    value: appointment.userName,
                  ),

                  _buildDetailRow(
                    icon: Icons.email_outlined,
                    label: 'Patient Email',
                    value: appointment.userEmail,
                  ),

                  _buildDetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Patient Phone',
                    value: appointment.userPhone,
                  ),

                  // Booking Date
                  _buildDetailRow(
                    icon: Icons.schedule,
                    label: 'Booked On',
                    value: DateFormat('MMM dd, yyyy at hh:mm a').format(appointment.createdAt),
                  ),

                  // Confirmed At (if confirmed)
                  if (appointment.confirmedAt != null)
                    _buildDetailRow(
                      icon: Icons.check_circle_outline,
                      label: 'Confirmed At',
                      value: DateFormat('MMM dd, yyyy at hh:mm a').format(appointment.confirmedAt!),
                    ),

                  // Cancelled At (if cancelled)
                  if (appointment.cancelledAt != null)
                    _buildDetailRow(
                      icon: Icons.cancel_outlined,
                      label: 'Cancelled At',
                      value: DateFormat('MMM dd, yyyy at hh:mm a').format(appointment.cancelledAt!),
                    ),

                  // Cancellation Reason (if cancelled)
                  if (appointment.cancellationReason != null && appointment.cancellationReason!.isNotEmpty)
                    _buildDetailRow(
                      icon: Icons.notes,
                      label: 'Cancellation Reason',
                      value: appointment.cancellationReason!,
                      isMultiline: true,
                    ),

                  const SizedBox(height: 30),

                  // Action Buttons
                  if (appointment.status.toLowerCase() == 'pending')
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle cancel appointment
                              _showCancelConfirmation(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cancel Appointment'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Handle reschedule appointment
                              Navigator.pop(context);
                              // Navigate to reschedule screen
                              _rescheduleAppointment(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDF4F5C),
                              side: const BorderSide(color: Color(0xFFDF4F5C)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Reschedule'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor ?? Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: const Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Handle cancel appointment logic here
                _cancelAppointment(context);
              },
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _cancelAppointment(BuildContext context) {
    // Implement cancel appointment logic
    // This would typically call your appointment service
    // AppointmentService().cancelAppointment(appointment.id);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment cancelled successfully'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _rescheduleAppointment(BuildContext context) {
    // Implement reschedule appointment logic
    // This would typically navigate to a reschedule screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => RescheduleScreen(appointment: appointment)));

    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reschedule functionality coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}