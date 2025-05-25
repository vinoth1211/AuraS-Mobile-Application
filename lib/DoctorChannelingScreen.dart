import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart';
// Add this import for your booking screen
import 'package:skincare_app/BookAppointment.dart';

class DoctorChannelingScreen extends StatelessWidget {
  const DoctorChannelingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Doctor Channelling'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ... Keep previous widgets (SearchBar, Image, etc.) ...
                       // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SearchBar(
                        hintText: 'Search Your Doctor',
                        leading: const Icon(Icons.search),
                      ),
                    ),

                    // Center Image
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(
                        'assets/images/Doctorimage.png', // Update with your image path
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Contact Your Doctor text
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Contact Your Doctor',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Short Description
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        'Book an appointment with doctor. Chat or talk with doctor and get consultations.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Horizontal Scroll Dermatologist Cards
                    SizedBox(
                      height: 320, // Increased height for button
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(20),
                        itemCount: 4, // Now 4 doctors
                        separatorBuilder: (context, index) => const SizedBox(width: 20),
                        itemBuilder: (context, index) => DermatologistCard(
                          doctorName: _doctors[index]['name'],
                          location: _doctors[index]['location'],
                          rating: _doctors[index]['rating'],
                          imagePath: _doctors[index]['image'],
                          description: _doctors[index]['description'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Doctor data
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Adithya',
      'location': 'Colombo, Sri Lanka',
      'rating': '4.9',
      'image': 'assets/images/doc1.png',
      'description': 'Board-certified dermatologist specializing in skin disorders. Expert in cosmetic dermatology.',
    },
    {
      'name': 'Dr. Samantha',
      'location': 'Kandy, Sri Lanka',
      'rating': '4.7',
      'image': 'assets/images/doc2.png',
      'description': 'Pediatric dermatology specialist with 10+ years experience in child skin care.',
    },
    {
      'name': 'Dr. Rajesh',
      'location': 'Galle, Sri Lanka',
      'rating': '4.8',
      'image': 'assets/images/doc3.png',
      'description': 'Acne treatment expert and laser therapy specialist. FDA-approved procedures.',
    },
    {
      'name': 'Dr. Anjali',
      'location': 'Jaffna, Sri Lanka',
      'rating': '4.6',
      'image': 'assets/images/Doctorimage.png',
      'description': 'Hair and scalp disorder specialist. Trichology certified practitioner.',
    },
  ];
}

class DermatologistCard extends StatelessWidget {
  final String doctorName;
  final String location;
  final String rating;
  final String imagePath;
  final String description;

  const DermatologistCard({
    super.key,
    required this.doctorName,
    required this.location,
    required this.rating,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToBooking(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF004237),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Avatar and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imagePath),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              doctorName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              location,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () => _navigateToBooking(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFE97171),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
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

  void _navigateToBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookAppointmentScreen(
          doctorName: doctorName,
          doctorImage: imagePath,
          doctorSpecialty: description,
        ),
      ),
    );
  }
}