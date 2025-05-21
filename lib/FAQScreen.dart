import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'FAQ'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Add your blog content here
                    const Center(child: Text('FAQ Screen Content')),
                    // Add more blog components below
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
