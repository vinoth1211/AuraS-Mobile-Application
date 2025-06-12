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
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 widget.dermatologist.location,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   const Icon(Icons.star, color: Colors.amber, size: 20),
//                   const SizedBox(width: 4),
//                   Text(
//                     widget.dermatologist.rating.toString(),
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.bold,
//                     ),
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
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         GestureDetector(
//           onTap: _selectDate,
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _selectedDate == null
//                       ? 'Choose a date'
//                       : DateFormat('EEE, MMM d, yyyy').format(_selectedDate!),
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: _selectedDate == null
//                         ? Colors.grey.shade500
//                         : Colors.black87,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Icon(
//                   Icons.calendar_today,
//                   color: Theme.of(context).primaryColor,
//                 ),
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
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         if (_loadingSlots)
//           const Center(
//             child: CircularProgressIndicator(),
//           )
//         else if (_selectedDate == null)
//           const Text(
//             'Please select a date first',
//             style: TextStyle(color: Colors.grey),
//           )
//         else if (_availableSlots.isEmpty)
//             const Text(
//               'No available slots for selected date',
//               style: TextStyle(color: Colors.grey),
//             )
//           else
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: _availableSlots.map((slot) {
//                 final isSelected = _selectedTime == slot;
//                 return GestureDetector(
//                   onTap: () => setState(() => _selectedTime = slot),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFF004237)
//                           : Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: isSelected
//                             ? const Color(0xFF004237)
//                             : Colors.grey.shade300,
//                       ),
//                     ),
//                     child: Text(
//                       slot.format(context),
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: isSelected ? Colors.white : Colors.black87,
//                       ),
//                     ),
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
//           elevation: 2,
//         ),
//         onPressed: _isBooking ? null : _bookAppointment,
//         child: _isBooking
//             ? const SizedBox(
//           width: 24,
//           height: 24,
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 3,
//           ),
//         )
//             : const Text(
//           'Book Appointment',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
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
//         final weekday = DateFormat('EEE').format(day);
//         return widget.dermatologist.workingDays.contains(weekday);
//       },
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF004237),
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xFF004237),
//               ),
//             ),
//           ),
//           child: child!,
//         );
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
//       final QuerySnapshot appointments = await _firestore
//           .collection('appointments')
//           .where('dermatologistId', isEqualTo: widget.dermatologist.id)
//           .where('date', isEqualTo: Timestamp.fromDate(_selectedDate!))
//           .where('status', whereIn: ['pending', 'confirmed'])
//           .get();
//
//       // Get booked time slots
//       final List<TimeOfDay> bookedSlots = appointments.docs.map((doc) {
//         final timeParts = (doc['time'] as String).split(':');
//         return TimeOfDay(
//           hour: int.parse(timeParts[0]),
//           minute: int.parse(timeParts[1]),
//         );
//       }).toList();
//
//       // Generate all possible slots
//       final List<TimeOfDay> allSlots = _generateTimeSlots(
//         widget.dermatologist.startTime,
//         widget.dermatologist.endTime,
//         const Duration(minutes: 30),
//       );
//
//       // Filter out booked slots
//       final List<TimeOfDay> availableSlots = allSlots.where((slot) {
//         return !bookedSlots.any((booked) =>
//         booked.hour == slot.hour && booked.minute == slot.minute);
//       }).toList();
//
//       setState(() => _availableSlots = availableSlots);
//     } catch (e) {
//       print("Error fetching slots: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to load available slots'),
//             backgroundColor: Colors.red.shade400,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _loadingSlots = false);
//       }
//     }
//   }
//
//   List<TimeOfDay> _generateTimeSlots(
//       TimeOfDay start,
//       TimeOfDay end,
//       Duration interval,
//       ) {
//     List<TimeOfDay> slots = [];
//     TimeOfDay current = start;
//
//     while (current.hour < end.hour ||
//         (current.hour == end.hour && current.minute < end.minute)) {
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
//         const SnackBar(
//           content: Text('Please select date and time'),
//           backgroundColor: Colors.orange,
//         ),
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
//         dermatologistName: widget.dermatologist.name,
//       );
//
//       // Add to Firestore
//       await _firestore.collection('appointments').add(appointment.toMap());
//
//       if (mounted) {
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Appointment booked successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         // Navigate back
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       print("Booking error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Booking failed: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isBooking = false);
//       }
//     }
//   }
// }







// // book_appointment_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'appointment_model.dart';
// import 'appointment_service.dart';
// import 'dermatologist_model.dart';
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
//   final AppointmentService _appointmentService = AppointmentService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Book Appointment',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.grey[200],
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDoctorProfile(),
//             const SizedBox(height: 32),
//             _buildDateSelector(),
//             const SizedBox(height: 32),
//             _buildTimeSlots(),
//             const SizedBox(height: 32),
//             _buildConsultationFee(),
//             const SizedBox(height: 32),
//             _buildBookButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDoctorProfile() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Hero(
//             tag: 'doctor_${widget.dermatologist.id}',
//             child: CircleAvatar(
//               radius: 40,
//               backgroundImage: AssetImage(widget.dermatologist.imageAsset),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.dermatologist.name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.dermatologist.specialization,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF004237),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.dermatologist.location,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.star, color: Colors.amber, size: 20),
//                     const SizedBox(width: 4),
//                     Text(
//                       widget.dermatologist.rating.toString(),
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateSelector() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Select Date',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 16),
//           GestureDetector(
//             onTap: _selectDate,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.grey[50],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _selectedDate == null
//                         ? 'Choose a date'
//                         : DateFormat('EEE, MMM d, yyyy').format(_selectedDate!),
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: _selectedDate == null
//                           ? Colors.grey.shade500
//                           : Colors.black87,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Icon(
//                     Icons.calendar_today,
//                     color: Colors.grey[600],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeSlots() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Available Time Slots',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           if (_loadingSlots)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: CircularProgressIndicator(
//                   color: Color(0xFF004237),
//                 ),
//               ),
//             )
//           else if (_selectedDate == null)
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.grey),
//                   SizedBox(width: 12),
//                   Text(
//                     'Please select a date first',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             )
//           else if (_availableSlots.isEmpty)
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.orange[50],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.schedule, color: Colors.orange),
//                     SizedBox(width: 12),
//                     Text(
//                       'No available slots for selected date',
//                       style: TextStyle(color: Colors.orange),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: _availableSlots.map((slot) {
//                   final isSelected = _selectedTime == slot;
//                   return GestureDetector(
//                     onTap: () => setState(() => _selectedTime = slot),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 16,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? const Color(0xFF004237)
//                             : Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: isSelected
//                               ? const Color(0xFF004237)
//                               : Colors.grey.shade300,
//                           width: isSelected ? 2 : 1,
//                         ),
//                         boxShadow: isSelected
//                             ? [
//                           BoxShadow(
//                             color: const Color(0xFF004237).withOpacity(0.3),
//                             spreadRadius: 1,
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ]
//                             : null,
//                       ),
//                       child: Text(
//                         slot.format(context),
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: isSelected ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildConsultationFee() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Consultation Fee',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           Text(
//             'Rs. ${widget.dermatologist.consultationFee.toStringAsFixed(0)}',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF004237),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF004237),
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 3,
//         ),
//         onPressed: _isBooking ? null : _bookAppointment,
//         child: _isBooking
//             ? const SizedBox(
//           width: 24,
//           height: 24,
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 3,
//           ),
//         )
//             : const Text(
//           'Book Appointment',
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
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
//         final weekday = DateFormat('EEE').format(day);
//         return widget.dermatologist.workingDays.contains(weekday);
//       },
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF004237),
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xFF004237),
//               ),
//             ),
//           ),
//           child: child!,
//         );
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
//       final availableSlots = await _appointmentService.getAvailableTimeSlots(
//         widget.dermatologist.id,
//         _selectedDate!,
//         widget.dermatologist.startTime,
//         widget.dermatologist.endTime,
//       );
//
//       if (mounted) {
//         setState(() => _availableSlots = availableSlots);
//       }
//     } catch (e) {
//       print("Error fetching slots: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to load available slots'),
//             backgroundColor: Colors.red.shade400,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _loadingSlots = false);
//       }
//     }
//   }
//
//   Future<void> _bookAppointment() async {
//     if (_selectedDate == null || _selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select date and time'),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//
//     setState(() => _isBooking = true);
//
//     try {
//       // Create appointment object
//       final appointment = Appointment(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         userId: widget.userId,
//         doctorId: widget.dermatologist.id,
//         doctorName: widget.dermatologist.name,
//         doctorSpecialization: widget.dermatologist.specialization,
//         doctorImageAsset: widget.dermatologist.imageAsset,
//         patientName: widget.userName,
//         patientEmail: widget.userEmail,
//         patientPhone: widget.userPhone,
//         appointmentDate: _selectedDate!,
//         appointmentTime: _selectedTime!,
//         consultationFee: widget.dermatologist.consultationFee,
//         status: AppointmentStatus.confirmed,
//         createdAt: DateTime.now(),
//       );
//
//       // Book the appointment
//       final success = await _appointmentService.bookAppointment(appointment);
//
//       if (mounted) {
//         if (success) {
//           // Show success dialog
//           _showBookingSuccessDialog(appointment);
//         } else {
//           // Show error message
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Failed to book appointment. Please try again.'),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print("Error booking appointment: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occurred: ${e.toString()}'),
//             backgroundColor: Colors.red.shade400,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isBooking = false);
//       }
//     }
//   }
//
//   void _showBookingSuccessDialog(Appointment appointment) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 20),
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF004237),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Appointment Booked!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Your appointment with ${widget.dermatologist.name} has been successfully booked.',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Date:',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         Text(
//                           DateFormat('MMM d, yyyy').format(appointment.appointmentDate),
//                           style: const TextStyle(color: Colors.black87),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Time:',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         Text(
//                           appointment.appointmentTime.format(context),
//                           style: const TextStyle(color: Colors.black87),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Fee:',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         Text(
//                           'Rs. ${appointment.consultationFee.toStringAsFixed(0)}',
//                           style: const TextStyle(
//                             color: Color(0xFF004237),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF004237),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close dialog
//                     Navigator.of(context).pop(); // Go back to previous screen
//                   },
//                   child: const Text(
//                     'Done',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dermatologist_model.dart';
import 'appointment_service.dart';
import 'appointment_model.dart';

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
  final AppointmentService _appointmentService = AppointmentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorProfile(),
            const SizedBox(height: 32),
            _buildDateSelector(),
            const SizedBox(height: 32),
            _buildTimeSlots(),
            const SizedBox(height: 32),
            _buildConsultationFee(),
            const SizedBox(height: 32),
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorProfile() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'doctor_${widget.dermatologist.id}',
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(widget.dermatologist.imageAsset),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error
              },
              child: widget.dermatologist.imageAsset.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
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
                  widget.dermatologist.specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF004237),
                    fontWeight: FontWeight.w600,
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.dermatologist.rating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
                color: Colors.grey[50],
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
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Color(0xFF004237),
                ),
              ),
            )
          else if (_selectedDate == null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 12),
                  Text(
                    'Please select a date first',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          else if (_availableSlots.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.orange),
                    SizedBox(width: 12),
                    Text(
                      'No available slots for selected date',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableSlots.map((slot) {
                  final isSelected = _selectedTime?.hour == slot.hour &&
                      _selectedTime?.minute == slot.minute;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = slot),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
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
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: const Color(0xFF004237).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : null,
                      ),
                      child: Text(
                        slot.format(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
        ],
      ),
    );
  }

  Widget _buildConsultationFee() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Consultation Fee',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Rs. ${widget.dermatologist.consultationFee.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004237),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004237),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
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
            fontSize: 18,
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
      });
      _fetchAvailableSlots();
    }
  }

  Future<void> _fetchAvailableSlots() async {
    if (_selectedDate == null) return;

    setState(() => _loadingSlots = true);

    try {
      final availableSlots = await _appointmentService.getAvailableTimeSlots(
        widget.dermatologist.id,
        _selectedDate!,
        widget.dermatologist.startTime,
        widget.dermatologist.endTime,
      );

      if (mounted) {
        setState(() => _availableSlots = availableSlots);
      }
    } catch (e) {
      debugPrint("Error fetching slots: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load available slots'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingSlots = false);
      }
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isBooking = true);

    try {
      // Create appointment object
      final appointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.userId,
        dermatologistId: widget.dermatologist.id,
        date: _selectedDate!,
        time: _selectedTime!,
        status: 'pending',
        userName: widget.userName,
        userEmail: widget.userEmail,
        userPhone: widget.userPhone,
        dermatologistName: widget.dermatologist.name,
        createdAt: DateTime.now(),
      );

      // Book the appointment
      final appointmentId = await _appointmentService.bookAppointment(appointment);

      if (mounted) {
        if (appointmentId.isNotEmpty) {
          // Show success dialog
          _showBookingSuccessDialog(appointment);
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to book appointment. Please try again.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error booking appointment: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBooking = false);
      }
    }
  }

  void _showBookingSuccessDialog(Appointment appointment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF004237),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Appointment Booked!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your appointment with ${widget.dermatologist.name} has been successfully booked.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          DateFormat('MMM d, yyyy').format(appointment.date),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          appointment.time.format(context),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fee:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Rs. ${widget.dermatologist.consultationFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF004237),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004237),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
