// import 'package:flutter/material.dart';
// import 'package:skincare_app/shared_widgets.dart';

// class AppointmentScreen extends StatelessWidget {
//   const AppointmentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomHeader(),
//             const CustomNavigationBar(activeRoute: 'Doctor Channelling'),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF8F8F8),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFFE97171),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               child: Text(
//                                 'My Appointments',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.arrow_back_ios),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _doctorCard(
//                         name: 'Dr. Adithya',
//                         imageUrl: 'assets/images/doc1.png',
//                         date: '21 May',
//                         time: '4:00 PM',
//                         location: 'Colombo Medical Center',
//                         rating: 4.5,
//                       ),
//                       _doctorCard(
//                         name: 'Dr. Arachchige',
//                         imageUrl: 'assets/images/doc2.png',
//                         date: '24 May',
//                         time: '6:00 PM',
//                         location: 'Kandy General Hospital',
//                         rating: 4.8,
//                       ),
//                       _doctorCard(
//                         name: 'Dr. Smith',
//                         imageUrl: 'assets/images/doc3.png',
//                         date: '30 May',
//                         time: '3:00 PM',
//                         location: 'Galle Health Clinic',
//                         rating: 4.2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _doctorCard({
//     required String name,
//     required String imageUrl,
//     required String date,
//     required String time,
//     required String location,
//     required double rating,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Left Section - Doctor Image
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: AssetImage(imageUrl),
//           ),
//           const SizedBox(width: 16),

//           // Middle Section - Doctor Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Doctor Name
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Location
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       location,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),

//                 // Rating Stars
//                 Row(
//                   children: [
//                     _buildStarRating(rating),
//                     const SizedBox(width: 8),
//                     Text(
//                       rating.toStringAsFixed(1),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.amber,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Right Section - Date, Time, Button
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               // Date
//               Text(
//                 date,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),

//               // Time
//               Text(
//                 time,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Start Now Button
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFE97171),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 ),
//                 child: const Text(
//                   'Start Now',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStarRating(double rating) {
//     return Row(
//       children: List.generate(5, (index) {
//         return Icon(
//           index < rating.floor() ? Icons.star : Icons.star_border,
//           color: Colors.amber,
//           size: 16,
//         );
//       }),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:skincare_app/shared_widgets.dart';

// class AppointmentScreen extends StatelessWidget {
//   const AppointmentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomHeader(),
//             const CustomNavigationBar(activeRoute: 'Doctor Channelling'),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF8F8F8),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFFE97171),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               child: Text(
//                                 'My Appointments',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.arrow_back_ios),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _doctorCard(
//                         name: 'Dr. Adithya',
//                         imageUrl: 'assets/images/doc1.png',
//                         date: '21 May',
//                         time: '4:00 PM',
//                         location: 'Colombo Medical Center',
//                         rating: 4.5,
//                       ),
//                       _doctorCard(
//                         name: 'Dr. Arachchige',
//                         imageUrl: 'assets/images/doc2.png',
//                         date: '24 May',
//                         time: '6:00 PM',
//                         location: 'Kandy General Hospital',
//                         rating: 4.8,
//                       ),
//                       _doctorCard(
//                         name: 'Dr. Smith',
//                         imageUrl: 'assets/images/doc3.png',
//                         date: '30 May',
//                         time: '3:00 PM',
//                         location: 'Galle Health Clinic',
//                         rating: 4.2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _doctorCard({
//     required String name,
//     required String imageUrl,
//     required String date,
//     required String time,
//     required String location,
//     required double rating,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Left Section - Doctor Image
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: AssetImage(imageUrl),
//           ),
//           const SizedBox(width: 16),

//           // Middle Section - Doctor Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Doctor Name
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Location
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       location,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),

//                 // Rating Stars
//                 Row(
//                   children: [
//                     _buildStarRating(rating),
//                     const SizedBox(width: 8),
//                     Text(
//                       rating.toStringAsFixed(1),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.amber,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Right Section - Date, Time, Button
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               // Date
//               Text(
//                 date,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),

//               // Time
//               Text(
//                 time,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Start Now Button
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFE97171),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 ),
//                 child: const Text(
//                   'Start Now',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStarRating(double rating) {
//     return Row(
//       children: List.generate(5, (index) {
//         return Icon(
//           index < rating.floor() ? Icons.star : Icons.star_border,
//           color: Colors.amber,
//           size: 16,
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

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
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE97171),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                'My Appointments',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _doctorCard(
                        name: 'Dr. Adithya',
                        imageUrl: 'assets/images/doc1.png',
                        date: '21 May',
                        time: '4:00 PM',
                        location: 'Colombo Medical Center',
                        rating: 4.5,
                      ),
                      _doctorCard(
                        name: 'Dr. Arachchige',
                        imageUrl: 'assets/images/doc2.png',
                        date: '24 May',
                        time: '6:00 PM',
                        location: 'Kandy General Hospital',
                        rating: 4.8,
                      ),
                      _doctorCard(
                        name: 'Dr. Smith',
                        imageUrl: 'assets/images/doc3.png',
                        date: '30 May',
                        time: '3:00 PM',
                        location: 'Galle Health Clinic',
                        rating: 4.2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard({
    required String name,
    required String imageUrl,
    required String date,
    required String time,
    required String location,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStarRating(rating),
                    const SizedBox(width: 8),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE97171),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Start Now',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}