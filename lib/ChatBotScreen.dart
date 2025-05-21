import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Chat Bot'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Add your blog content here
                    const Center(child: Text('Chat Bot Screen Content')),
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