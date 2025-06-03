import 'package:flutter/material.dart';
import 'package:skincare_app/shared_widgets.dart';
// Import chatbot screen

class ChatHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatHistory = [
    {
      'date': '2023-07-20',
      'messages': [
        {
          'text': 'I have dry and flaky skin on my face.',
          'isUser': true,
          'time': '9:41 AM',
        },
        {
          'text': 'Try a gentle, hydrating moisturizer...',
          'isUser': false,
          'time': '9:42 AM',
        },
      ],
    },
    {
      'date': '2023-07-19',
      'messages': [
        {
          'text': 'I have dark spots that won’t fade away.',
          'isUser': true,
          'time': '4:30 PM',
        },
        {
          'text': 'Use a serum with vitamin C...',
          'isUser': false,
          'time': '4:31 PM',
        },
      ],
    },
  ];

  ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Chat Bot'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Your Conversation History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final history = chatHistory[index];
                  return GestureDetector(
                    onTap:
                        () => _navigateToChatDetails(
                          context,
                          history['messages'],
                        ),
                    child: _buildHistoryItem(history),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatDetails(BuildContext context, List<dynamic> messages) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PastChatScreen(messages: messages),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              history['date'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // color: Colors.blue,
                color: Color.fromARGB(255, 206, 55, 45) ,

                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...history['messages']
                .map<Widget>(
                  (message) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          message['time'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            message['text'],
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  message['isUser']
                                      ? Color.fromARGB(255, 206, 55, 45)
                                      : Colors.grey.shade700,
                              fontStyle:
                                  message['isUser']
                                      ? FontStyle.normal
                                      : FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class PastChatScreen extends StatelessWidget {
  final List<dynamic> messages;

  const PastChatScreen({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Chat Bot'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Past Conversation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder:
                    (context, index) => _buildMessageBubble(messages[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Align(
      alignment:
          message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              message['isUser']
                  ? Color.fromARGB(255, 206, 55, 45)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border:
              message['isUser']
                  ? null
                  : Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: message['isUser'] ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message['time'],
              style: TextStyle(
                color:
                    message['isUser'] ? Colors.white70 : Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
