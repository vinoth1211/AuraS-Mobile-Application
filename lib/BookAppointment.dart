import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int? selectedDateIndex;
  int? selectedTimeIndex;

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
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/doctors/dr_kasun.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dr. Kasun',
                      style: TextStyle(
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
                          '4.8',
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
            // Days Row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sun', style: TextStyle(color: Colors.grey)),
                Text('Mon', style: TextStyle(color: Colors.grey)),
                Text('Tue', style: TextStyle(color: Colors.grey)),
                Text('Wed', style: TextStyle(color: Colors.grey)),
                Text('Thu', style: TextStyle(color: Colors.grey)),
                Text('Fri', style: TextStyle(color: Colors.grey)),
                Text('Sat', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            // Dates Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final dates = [22, 23, 24, 25, 26, 27, 28];
                return GestureDetector(
                  onTap: () => setState(() => selectedDateIndex = index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedDateIndex == index
                          ? Colors.green
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedDateIndex == index
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${dates[index]}',
                      style: TextStyle(
                        color: selectedDateIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildTimeSlot('8.00 AM', 0),
                _buildTimeSlot('9.30 AM', 1),
                _buildTimeSlot('10.00 AM', 2),
                _buildTimeSlot('10.30 AM', 3),
                _buildTimeSlot('11.00 AM', 4),
                _buildTimeSlot('11.30 AM', 5),
                _buildTimeSlot('12.00 PM', 6),
                _buildTimeSlot('12.30 PM', 7),
                _buildTimeSlot('2.00 PM', 8),
              ],
            ),
            const SizedBox(height: 32),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle booking logic
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

  Widget _buildTimeSlot(String time, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedTimeIndex = index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedTimeIndex == index
              ? Colors.green.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedTimeIndex == index ? Colors.green : Colors.grey,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: selectedTimeIndex == index ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }
}