//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dermatologist_model.dart';
//
// class BookAppointmentScreen extends StatefulWidget {
//   final Dermatologist dermatologist;
//
//   const BookAppointmentScreen({super.key, required this.dermatologist});
//
//   @override
//   State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
// }
//
// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   final List<String> timeSlots = [
//     '8:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
//     '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM', '2:00 PM'
//   ];
//
//   // Function to show date picker
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(DateTime.now().year + 1),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   // Function to show time picker
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Doctor Profile Section
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundImage: AssetImage(widget.dermatologist.imageAsset),
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.dermatologist.name,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Dermatologist',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 20),
//                         const SizedBox(width: 4),
//                         Text(
//                           widget.dermatologist.rating.toStringAsFixed(1),
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),
//
//             // Date Selection
//             const Text(
//               'Select Date',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//
//             // Date Picker Button
//             GestureDetector(
//               onTap: () => _selectDate(context),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _selectedDate == null
//                           ? 'Choose a date'
//                           : DateFormat.yMMMMd().format(_selectedDate!),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: _selectedDate == null ? Colors.grey : Colors.black,
//                       ),
//                     ),
//                     const Icon(Icons.calendar_today, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Time Selection
//             const Text(
//               'Select Time',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//
//             // Time Picker Button
//             GestureDetector(
//               onTap: () => _selectTime(context),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _selectedTime == null
//                           ? 'Choose a time'
//                           : _selectedTime!.format(context),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: _selectedTime == null ? Colors.grey : Colors.black,
//                       ),
//                     ),
//                     const Icon(Icons.access_time, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Book Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF004237),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (_selectedDate == null || _selectedTime == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please select date and time'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   } else {
//                     // Format the selected date and time
//                     final formattedDate = DateFormat.yMMMMd().format(_selectedDate!);
//                     final formattedTime = _selectedTime!.format(context);
//
//                     // Handle successful booking
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             'Appointment booked with ${widget.dermatologist.name} '
//                                 'on $formattedDate at $formattedTime'
//                         ),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//
//                     // You can add navigation or other logic here after booking
//                   }
//                 },
//                 child: const Text(
//                   'Book an Appointment',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'appointment_model.dart';
// import 'dermatologist_model.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class BookAppointmentScreen extends StatefulWidget {
//   final Dermatologist dermatologist;
//   final String userId;
//   final String userName;
//   final String userEmail;
//   final String userPhone;
//
//   const BookAppointmentScreen({
//     super.key,
//     required this.dermatologist,
//     required this.userId,
//     required this.userName,
//     required this.userEmail,
//     required this.userPhone,
//   });
//
//   @override
//   State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
// }
//
// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   List<TimeOfDay> _availableSlots = [];
//   bool _loadingSlots = false;
//   bool _isBooking = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Book Appointment'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Doctor Profile Section
//             _buildDoctorProfile(),
//             const SizedBox(height: 32),
//
//             // Date Selection
//             _buildDateSelector(),
//             const SizedBox(height: 32),
//
//             // Time Slot Selection
//             _buildTimeSlots(),
//             const SizedBox(height: 32),
//
//             // Book Button
//             _buildBookButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDoctorProfile() {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 40,
//           backgroundImage: AssetImage(widget.dermatologist.imageAsset),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.dermatologist.name,
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 'Dermatologist',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   const Icon(Icons.star, color: Colors.amber, size: 20),
//                   const SizedBox(width: 4),
//                   Text(
//                     widget.dermatologist.rating.toString(),
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDateSelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Select Date',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         GestureDetector(
//           onTap: _selectDate,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _selectedDate == null
//                       ? 'Choose a date'
//                       : DateFormat.yMMMMd().format(_selectedDate!),
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: _selectedDate == null ? Colors.grey : Colors.black,
//                   ),
//                 ),
//                 const Icon(Icons.calendar_today, color: Colors.grey),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimeSlots() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Available Time Slots',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//
//         if (_loadingSlots)
//           const Center(child: CircularProgressIndicator())
//         else if (_selectedDate == null)
//           const Text('Please select a date first')
//         else if (_availableSlots.isEmpty)
//             const Text('No available slots for selected date')
//           else
//             Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: _availableSlots.map((slot) {
//                 final isSelected = _selectedTime == slot;
//                 return ChoiceChip(
//                   label: Text(slot.format(context)),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     setState(() => _selectedTime = selected ? slot : null);
//                   },
//                   selectedColor: Colors.green[100],
//                   labelStyle: TextStyle(
//                     color: isSelected ? Colors.green : Colors.black,
//                   ),
//                 );
//               }).toList(),
//             ),
//       ],
//     );
//   }
//
//   Widget _buildBookButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF004237),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: _isBooking ? null : _bookAppointment,
//         child: _isBooking
//             ? const CircularProgressIndicator(color: Colors.white)
//             : const Text(
//           'Book Appointment',
//           style: TextStyle(fontSize: 16, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 60)),
//       selectableDayPredicate: (day) {
//         final weekday = DateFormat.E().format(day).substring(0, 3);
//         return widget.dermatologist.workingDays.contains(weekday);
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedTime = null;
//         _fetchAvailableSlots();
//       });
//     }
//   }
//
//   Future<void> _fetchAvailableSlots() async {
//     if (_selectedDate == null) return;
//
//     setState(() => _loadingSlots = true);
//
//     try {
//       // Fetch existing appointments
//       final appointments = await FirebaseFirestore.instance
//           .collection('appointments')
//           .where('dermatologistId', isEqualTo: widget.dermatologist.id)
//           .where('date', isEqualTo: Timestamp.fromDate(_selectedDate!))
//           .where('status', whereIn: ['pending', 'confirmed'])
//           .get();
//
//       // Get booked time slots
//       final bookedSlots = appointments.docs.map((doc) {
//         final timeParts = doc['time'].split(':');
//         return TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
//       }).toList();
//
//       // Generate all possible slots
//       final allSlots = _generateTimeSlots(
//         widget.dermatologist.startTime,
//         widget.dermatologist.endTime,
//         const Duration(minutes: 30),
//       );
//
//       // Filter out booked slots
//       final availableSlots = allSlots.where((slot) {
//         return !bookedSlots.any((booked) =>
//         booked.hour == slot.hour && booked.minute == slot.minute);
//       }).toList();
//
//       setState(() => _availableSlots = availableSlots);
//     } catch (e) {
//       print("Error fetching slots: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load available slots')),
//       );
//     } finally {
//       setState(() => _loadingSlots = false);
//     }
//   }
//
//   List<TimeOfDay> _generateTimeSlots(TimeOfDay start, TimeOfDay end, Duration interval) {
//     List<TimeOfDay> slots = [];
//     TimeOfDay current = start;
//
//     while (current.hour < end.hour ||
//         (current.hour == end.hour && current.minute <= end.minute)) {
//       slots.add(current);
//
//       // Add interval
//       int totalMinutes = current.hour * 60 + current.minute + interval.inMinutes;
//       current = TimeOfDay(
//         hour: totalMinutes ~/ 60,
//         minute: totalMinutes % 60,
//       );
//     }
//
//     return slots;
//   }
//
//   Future<void> _bookAppointment() async {
//     if (_selectedDate == null || _selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select date and time')),
//       );
//       return;
//     }
//
//     setState(() => _isBooking = true);
//
//     try {
//       // Create appointment object
//       final appointment = Appointment(
//         id: '', // Will be generated by Firestore
//         userId: widget.userId,
//         dermatologistId: widget.dermatologist.id,
//         date: _selectedDate!,
//         time: _selectedTime!,
//         status: 'pending',
//         userName: widget.userName,
//         userEmail: widget.userEmail,
//         userPhone: widget.userPhone,
//       );
//
//       // Add to Firestore
//       await FirebaseFirestore.instance
//           .collection('appointments')
//           .add(appointment.toMap());
//
//       // Notify dermatologist via email (would be done via Cloud Function)
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Appointment booked successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       Navigator.pop(context);
//     } catch (e) {
//       print("Booking error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Booking failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => _isBooking = false);
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'appointment_model.dart';
import 'dermatologist_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Dermatologist dermatologist;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;

  const BookAppointmentScreen({
    super.key,
    required this.dermatologist,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<TimeOfDay> _availableSlots = [];
  bool _loadingSlots = false;
  bool _isBooking = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Section
            _buildDoctorProfile(),
            const SizedBox(height: 32),

            // Date Selection
            _buildDateSelector(),
            const SizedBox(height: 32),

            // Time Slot Selection
            _buildTimeSlots(),
            const SizedBox(height: 32),

            // Book Button
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(widget.dermatologist.imageAsset),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.dermatologist.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.dermatologist.location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.dermatologist.rating.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Choose a date'
                      : DateFormat('EEE, MMM d, yyyy').format(_selectedDate!),
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate == null
                        ? Colors.grey.shade500
                        : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        if (_loadingSlots)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (_selectedDate == null)
          const Text(
            'Please select a date first',
            style: TextStyle(color: Colors.grey),
          )
        else if (_availableSlots.isEmpty)
            const Text(
              'No available slots for selected date',
              style: TextStyle(color: Colors.grey),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableSlots.map((slot) {
                final isSelected = _selectedTime == slot;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = slot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF004237)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF004237)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      slot.format(context),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
      ],
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004237),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _isBooking ? null : _bookAppointment,
        child: _isBooking
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      selectableDayPredicate: (day) {
        final weekday = DateFormat('EEE').format(day);
        return widget.dermatologist.workingDays.contains(weekday);
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF004237),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF004237),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
        _fetchAvailableSlots();
      });
    }
  }

  Future<void> _fetchAvailableSlots() async {
    if (_selectedDate == null) return;

    setState(() => _loadingSlots = true);

    try {
      // Fetch existing appointments
      final QuerySnapshot appointments = await _firestore
          .collection('appointments')
          .where('dermatologistId', isEqualTo: widget.dermatologist.id)
          .where('date', isEqualTo: Timestamp.fromDate(_selectedDate!))
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

      // Generate all possible slots
      final List<TimeOfDay> allSlots = _generateTimeSlots(
        widget.dermatologist.startTime,
        widget.dermatologist.endTime,
        const Duration(minutes: 30),
      );

      // Filter out booked slots
      final List<TimeOfDay> availableSlots = allSlots.where((slot) {
        return !bookedSlots.any((booked) =>
        booked.hour == slot.hour && booked.minute == slot.minute);
      }).toList();

      setState(() => _availableSlots = availableSlots);
    } catch (e) {
      print("Error fetching slots: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load available slots'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingSlots = false);
      }
    }
  }

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

  Future<void> _bookAppointment() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isBooking = true);

    try {
      // Create appointment object
      final appointment = Appointment(
        id: '', // Will be generated by Firestore
        userId: widget.userId,
        dermatologistId: widget.dermatologist.id,
        date: _selectedDate!,
        time: _selectedTime!,
        status: 'pending',
        userName: widget.userName,
        userEmail: widget.userEmail,
        userPhone: widget.userPhone,
        dermatologistName: widget.dermatologist.name,
      );

      // Add to Firestore
      await _firestore.collection('appointments').add(appointment.toMap());

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      print("Booking error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBooking = false);
      }
    }
  }
}