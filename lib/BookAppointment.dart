
// import 'package:flutter/material.dart';
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
//   int? selectedDateIndex;
//   int? selectedTimeIndex;
//   final List<int> dates = [22, 23, 24, 25, 26, 27, 28];
//   final List<String> timeSlots = [
//     '8.00 AM', '9.30 AM', '10.00 AM', '10.30 AM',
//     '11.00 AM', '11.30 AM', '12.00 PM', '12.30 PM', '2.00 PM'
//   ];
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
//             // Days of the week
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Sun', style: TextStyle(color: Colors.grey)),
//                 Text('Mon', style: TextStyle(color: Colors.grey)),
//                 Text('Tue', style: TextStyle(color: Colors.grey)),
//                 Text('Wed', style: TextStyle(color: Colors.grey)),
//                 Text('Thu', style: TextStyle(color: Colors.grey)),
//                 Text('Fri', style: TextStyle(color: Colors.grey)),
//                 Text('Sat', style: TextStyle(color: Colors.grey)),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Date selection buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(7, (index) {
//                 return GestureDetector(
//                   onTap: () => setState(() => selectedDateIndex = index),
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: selectedDateIndex == index
//                           ? Colors.green
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: selectedDateIndex == index
//                             ? Colors.green
//                             : Colors.grey,
//                       ),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '${dates[index]}',
//                       style: TextStyle(
//                         color: selectedDateIndex == index
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
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
//             // Time slots
//             Column(
//               children: List.generate(timeSlots.length, (index) {
//                 return _buildTimeSlot(timeSlots[index], index);
//               }),
//             ),
//             const SizedBox(height: 32),
//
//             // Book Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (selectedDateIndex == null || selectedTimeIndex == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please select date and time'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   } else {
//                     // Handle successful booking
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             'Appointment booked with ${widget.dermatologist.name} '
//                                 'on ${dates[selectedDateIndex!]} at ${timeSlots[selectedTimeIndex!]}'
//                         ),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
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
//
//   Widget _buildTimeSlot(String time, int index) {
//     return GestureDetector(
//       onTap: () => setState(() => selectedTimeIndex = index),
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         decoration: BoxDecoration(
//           color: selectedTimeIndex == index
//               ? Colors.green.withOpacity(0.1)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: selectedTimeIndex == index ? Colors.green : Colors.grey,
//           ),
//         ),
//         child: Text(
//           time,
//           style: TextStyle(
//             color: selectedTimeIndex == index ? Colors.green : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dermatologist_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Dermatologist dermatologist;

  const BookAppointmentScreen({super.key, required this.dermatologist});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final List<String> timeSlots = [
    '8:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM', '2:00 PM'
  ];

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.dermatologist.imageAsset),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dermatologist.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Dermatologist',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          widget.dermatologist.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Date Picker Button
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Choose a date'
                          : DateFormat.yMMMMd().format(_selectedDate!),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Time Picker Button
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime == null
                          ? 'Choose a time'
                          : _selectedTime!.format(context),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedTime == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    const Icon(Icons.access_time, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004237),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select date and time'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Format the selected date and time
                    final formattedDate = DateFormat.yMMMMd().format(_selectedDate!);
                    final formattedTime = _selectedTime!.format(context);

                    // Handle successful booking
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Appointment booked with ${widget.dermatologist.name} '
                                'on $formattedDate at $formattedTime'
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // You can add navigation or other logic here after booking
                  }
                },
                child: const Text(
                  'Book an Appointment',
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
      ),
    );
  }
}