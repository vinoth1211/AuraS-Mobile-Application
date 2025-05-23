// shared_widgets.dart
import 'package:flutter/material.dart';
import 'package:skincare_app/AIAnalysisScreen.dart';
import 'package:skincare_app/BlogScreen.dart';
import 'package:skincare_app/ChatBotScreen.dart';
import 'package:skincare_app/DoctorChannelingScreen.dart';
import 'package:skincare_app/FAQScreen.dart';
import 'package:skincare_app/home_page.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'AuraS',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.red),
                onPressed: () {},
              ),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://placehold.co/100x100'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final String activeRoute;

  const CustomNavigationBar({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _NavItem(
              title: 'Home',
              isActive: activeRoute == 'Home',
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  ),
            ),
            _NavItem(
              title: 'AI Analysis',
              isActive: activeRoute == 'AI Analysis',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SkinAnalysisPage(),
                    ),
                  ),
            ),
            _NavItem(
              title: 'Chat Bot',
              isActive: activeRoute == 'Chat Bot',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatBotScreen(),
                    ),
                  ),
            ),
            _NavItem(
              title: 'Doctor Channelling',
              isActive: activeRoute == 'Doctor Channelling',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorChannelingScreen(),
                    ),
                  ),
            ),
            _NavItem(
              title: 'Blog',
              isActive: activeRoute == 'Blog',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BlogScreen()),
                  ),
            ),
            _NavItem(
              title: 'FAQ',
              isActive: activeRoute == 'FAQ',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text with intrinsic width measurement
            IntrinsicWidth(
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (isActive)
                    Container(
                      height: 2,
                      color: const Color(0xFFDF4F5C),
                      margin: const EdgeInsets.only(top: 4),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
