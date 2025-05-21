import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart'; // assuming you have CustomHeader & CustomNavigationBar

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           const CustomHeader(),
  //           const CustomNavigationBar(activeRoute: 'Blog'),
  //           Expanded(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(height: 20),
  //                   const Center(
  //                     child: Text(
  //                       'RECENT POSTS',
  //                       style: TextStyle(
  //                         fontSize: 22,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),

  //                   // Blog Card 1
  //                   _blogCard(
  //                     title: 'Smart SPF Protection',
  //                     imageUrl: 'assets/images/image1.png',
  //                     description:
  //                         'Sunscreens are evolving to offer broader protection against UV rays, blue light, and pollution. Innovations include powder and mist SPF formats that are easy to apply and reapply throughout the day.',
  //                   ),

  //                   // Blog Card 2
  //                   _blogCard(
  //                     title: 'Neurocosmetics',
  //                     imageUrl: 'assets/images/image2.png',
  //                     description:
  //                         'Neurocosmetics focus on the connection between emotional well-being and skin health. Products infused with adaptogens and neuropeptides aim to reduce stress-induced skin issues, promoting a holistic approach to skincare.',
  //                   ),

  //                   // Blog Card 3
  //                   _blogCard(
  //                     title: 'Microbiome Skincare',
  //                     imageUrl: 'assets/images/image7.png',
  //                     description:
  //                         'Microbiome skincare targets the balance of good bacteria on the skin’s surface. Products with prebiotics, probiotics, and postbiotics help strengthen the skin barrier, reduce inflammation, and support a healthy, resilient complexion.',
  //                   ),
  //                   const SizedBox(height: 20),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          const CustomHeader(),
          const CustomNavigationBar(activeRoute: 'Blog'),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16), // Space from navigation bar
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9), // Light gray background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'RECENT POSTS',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Blog Card 1
                    _blogCard(
                      title: 'Smart SPF Protection',
                      imageUrl: 'assets/images/image1.png',
                      description:
                          'Sunscreens are evolving to offer broader protection against UV rays, blue light, and pollution. Innovations include powder and mist SPF formats that are easy to apply and reapply throughout the day.',
                    ),

                    // Blog Card 2
                    _blogCard(
                      title: 'Neurocosmetics',
                      imageUrl: 'assets/images/image2.png',
                      description:
                          'Neurocosmetics focus on the connection between emotional well-being and skin health. Products infused with adaptogens and neuropeptides aim to reduce stress-induced skin issues, promoting a holistic approach to skincare.',
                    ),

                    // Blog Card 3
                    _blogCard(
                      title: 'Microbiome Skincare',
                      imageUrl: 'assets/images/image7.png',
                      description:
                          'Microbiome skincare targets the balance of good bacteria on the skin’s surface. Products with prebiotics, probiotics, and postbiotics help strengthen the skin barrier, reduce inflammation, and support a healthy, resilient complexion.',
                    ),

                    const SizedBox(height: 20),
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


  static Widget _blogCard({
    required String title,
    required String imageUrl,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF3C3A1E), // Dark olive green background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFE0E0), // Light pink
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Center(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity, // fills the card width
                height: 200, // you can adjust this height
                alignment: Alignment.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
