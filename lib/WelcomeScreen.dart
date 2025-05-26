import 'package:flutter/material.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome to',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              _buildLogo(),
              const SizedBox(height: 16),
              const Text(
                'AuraS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Personal Skincare Companion!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              _buildUserIcons(),
              const SizedBox(height: 24),
              const Text(
                'Discover healthier skin with smart AI scanning,\nexpert dermatologist support,\nand a 24/7 chatbot ready to guide you anytime.\nLet\'s begin your journey to better skin today!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },

                child: const Text('Get Started'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Image.asset(
        'assets/images/logo.png', // Your logo image path
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildUserIcons() {
    return Center(
      child: ClipOval(
        child: Container(
          color: const Color(0xFFE94057).withOpacity(0.2),
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/Icon.png', // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Custom painter for creating the logo's triangular shapes

  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Main onboarding flow after welcome screen
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Smart Skin Analysis',
      description:
          'Take a photo and get instant AI-powered skin analysis for personalized care recommendations.',
      icon: Icons.camera_alt,
    ),
    OnboardingItem(
      title: 'Expert Support',
      description:
          'Connect with certified dermatologists for professional advice on your skin concerns.',
      icon: Icons.medical_services,
    ),
    OnboardingItem(
      title: '24/7 Skin Assistant',
      description:
          'Our AI chatbot is always ready to answer your skincare questions and guide your routine.',
      icon: Icons.chat,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      _onboardingItems.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 10,
                        width: _currentPage == index ? 25 : 10,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  // Next or Get Started button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _onboardingItems.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigate to main app
                        // TODO: Add navigation to home screen
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 50),
                    ),
                    child: Text(
                      _currentPage < _onboardingItems.length - 1
                          ? 'Next'
                          : 'Get Started',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 100, color: Theme.of(context).primaryColor),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
