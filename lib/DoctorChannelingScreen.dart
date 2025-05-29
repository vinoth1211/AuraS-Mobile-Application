import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart';

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
                      height: 300, // Adjust based on your needs
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(20),
                        itemCount: 5, // Replace with your actual item count
                        separatorBuilder: (context, index) => const SizedBox(width: 20),
                        itemBuilder: (context, index) => DermatologistCard(),
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
}

class DermatologistCard extends StatelessWidget {
  const DermatologistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              // Doctor Avatar
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/doc1.png'), // Add your image
              ),
              
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Doctor Name
          const Text(
            'Dr. Adithya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Location
          const Text(
            'Colombo, Sri Lanka',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 15),

          // Description
          const Expanded(
            child: Text(
              'Board-certified dermatologist specializing in skin, hair, and nail disorders. Expert in both medical and cosmetic dermatology.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}