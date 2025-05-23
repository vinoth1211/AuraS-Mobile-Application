import 'package:flutter/material.dart';
import 'package:skincare_app/AppointmentScreen.dart';
import 'package:skincare_app/AIAnalysisScreen.dart';
import 'package:skincare_app/ChatBotScreen.dart';
import 'package:skincare_app/DoctorChannelingScreen.dart';
// import 'package:skincare_app/AIAnalysisScreen.dart';
// import 'package:skincare_app/BlogScreen.dart';
// import 'package:skincare_app/ChatBotScreen.dart';
// import 'package:skincare_app/DoctorChannelingScreen';
// import 'package:skincare_app/FAQScreen.dart';
import 'package:skincare_app/shared_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Home'), // Pass context here
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReminderBanner(context),
                    _buildFeaturesSection(context),
                    _buildLatestUpdatesSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             SizedBox(
  //               width: 50,
  //               height: 50,
  //               child: ClipOval(
  //                 child: Image.asset(
  //                   'assets/images/logo.png',
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             const Text(
  //               'AuraS',
  //               style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             IconButton(
  //               icon: const Icon(Icons.menu, color: Colors.red),
  //               onPressed: () {},
  //             ),
  //             const CircleAvatar(
  //               radius: 20,
  //               backgroundImage: NetworkImage('https://placehold.co/100x100'),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildNavBar(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     decoration: const BoxDecoration(
  //       border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
  //     ),
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: [
  //           const SizedBox(width: 16),
  //           _navItem(
  //             'Home',
  //             isActive: true,
  //             onTap: () => Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => const HomePage()),
  //             ),
  //           ),
  //           _navItem(
  //             'AI Analysis',
  //             onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const AIAnalysisScreen()),
  //             ),
  //           ),
  //           _navItem(
  //             'Chat Bot',
  //             onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const ChatBotScreen()),
  //             ),
  //           ),
  //           _navItem(
  //             'Doctor Channelling',
  //             onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const DoctorChannelingScreen()),
  //             ),
  //           ),
  //           _navItem(
  //             'Blog',
  //             onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const BlogScreen()),
  //             ),
  //           ),
  //           _navItem(
  //             'FAQ',
  //             onTap: () => Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const FAQScreen()),
  //             ),
  //           ),
  //           const SizedBox(width: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _navItem(String title, {bool isActive = false, VoidCallback? onTap}) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8),
  //       child: Column(
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
  //               color: isActive ? Colors.black : Colors.grey,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           if (isActive)
  //             Container(height: 2, width: 40, color: const Color(0xFFDF4F5C)),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildReminderBanner() {
  //   return Container(
  //     margin: const EdgeInsets.all(16),
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[300],
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 24,
  //           height: 24,
  //           decoration: const BoxDecoration(
  //             color: Color(0xFFFFCB05),
  //             shape: BoxShape.circle,
  //           ),
  //           child: const Center(
  //             child: Text(
  //               '!',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: const [
  //             Text('Reminders', style: TextStyle(color: Color(0xFF666666))),
  //             Text('1 Appointment', style: TextStyle(color: Color(0xFF666666))),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildReminderBanner(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AppointmentScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFFCB05),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Reminders', style: TextStyle(color: Color(0xFF666666))),
                Text(
                  '1 Appointment',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFeaturesSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16),
  //         child: Text(
  //           'Our features',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: _buildFeatureCard(
  //                 color: const Color(0xFFFFF9E6),
  //                 iconColor: const Color(0xFFFFCB05),
  //                 icon: Icons.grid_view,
  //                 title: 'AI Skin Analysis',
  //                 description:
  //                     'AI skin analysis uses advanced image processing to detect skin concerns like acne, wrinkles, and dryness. It provides quick, personalized feedback and care suggestions based on your skin\'s condition.',
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildFeatureCard(
  //                 color: const Color(0xFFE0F5F0),
  //                 iconColor: const Color(0xFFA0E0D0),
  //                 icon: Icons.chat_bubble_outline_sharp,
  //                 title: 'AI Chatbot',
  //                 description:
  //                     'A smart virtual assistant that uses AI to understand and respond to user queries in real time',
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: _buildFeatureCard(
  //           color: Colors.grey[200]!,
  //           iconColor: Colors.black,
  //           icon: Icons.medical_services_outlined,
  //           title: 'Doctor Channelling',
  //           description:
  //               'Doctor channelling is a simple way to book appointments with doctors through a phone or online. It helps patients find the right doctor and choose a convenient time without waiting in long lines.',
  //           isFullWidth: true,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Our features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SkinAnalysisPage(),
                      ),
                    );
                  },
                  child: _buildFeatureCard(
                    color: const Color(0xFFFFF9E6),
                    iconColor: const Color(0xFFFFCB05),
                    icon: Icons.grid_view,
                    title: 'AI Skin Analysis',
                    description:
                        'AI skin analysis uses advanced image processing to detect skin concerns like acne, wrinkles, and dryness. It provides quick, personalized feedback and care suggestions based on your skin\'s condition.',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatBotScreen(),
                      ),
                    );
                  },
                  child: _buildFeatureCard(
                    color: const Color(0xFFE0F5F0),
                    iconColor: const Color(0xFFA0E0D0),
                    icon: Icons.chat_bubble_outline_sharp,
                    title: 'AI Chatbot',
                    description:
                        'A smart virtual assistant that uses AI to understand and respond to user queries in real time',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoctorChannelingScreen(),
                ),
              );
            },
            child: _buildFeatureCard(
              color: Colors.grey[200]!,
              iconColor: Colors.black,
              icon: Icons.medical_services_outlined,
              title: 'Doctor Channelling',
              description:
                  'Doctor channelling is a simple way to book appointments with doctors through a phone or online. It helps patients find the right doctor and choose a convenient time without waiting in long lines.',
              isFullWidth: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String description,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestUpdatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Latest Skincare Updates',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildUpdateCard(
                title: 'Smart SPF Protection',
                backgroundColor: const Color(0xFF654321),
                images: [
                  'assets/images/image1.png', // Main image
                  'assets/images/image2.png', // Top small image
                  'assets/images/image3.png', // Bottom small image
                ],
                description:
                    'Sunscreens are evolving to offer broader protection against UV rays, blue light, and pollution. Innovations include powder and mist SPF formats that are easy to apply and reapply throughout the day.',
              ),
              const SizedBox(width: 12),
              _buildUpdateCard(
                title: 'Neurocosmetics',
                backgroundColor: const Color(0xFF654321),
                images: [
                  'assets/images/image4.png', // Main image
                  'assets/images/image5.png', // Top small image
                  'assets/images/image6.png', // Bottom small image
                ],
                description:
                    'A new frontier between skin health. Products target connections between environmental factors and neurophysiology-induced skin conditions.',
              ),
              const SizedBox(width: 12),
              _buildUpdateCard(
                title: 'Microbiome Skincare',
                backgroundColor: const Color(0xFF654321),
                images: [
                  'assets/images/image7.png', // Main image
                  'assets/images/image8.png', // Top small image
                  'assets/images/image9.png', // Bottom small image
                ],
                description:
                    'Microbiome skincare targets the balance of good bacteria on the skin’s surface. Products with prebiotics, probiotics, and postbiotics help strengthen the skin barrier, reduce inflammation, and support a healthy, resilient complexion.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateCard({
    required String title,
    required List<String> images,
    required String description,
    required Color backgroundColor,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 🖼️ Image Row: Main image + 2 small images stacked vertically
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  images[0],
                  width: 180,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              // 2 small images in a column
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      images[1],
                      width: 60,
                      height: 58,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      images[2],
                      width: 60,
                      height: 58,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
