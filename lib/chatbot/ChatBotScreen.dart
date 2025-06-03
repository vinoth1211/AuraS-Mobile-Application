import 'package:flutter/material.dart';
import 'package:skincare_app/chatbot/chat_history_screen.dart';
import 'package:skincare_app/shared_widgets.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'I have dry and flaky skin on my face.',
      'isUser': true,
      'timestamp': '9:41',
    },
    {
      'text':
          'Try a gentle, hydrating moisturizer with hyaluronic acid to lock in moisture.',
      'isUser': false,
      'timestamp': '9:42',
    },
    {
      'text': 'I’m getting frequent breakouts on my cheeks.',
      'isUser': true,
      'timestamp': '9:43',
    },
    {
      'text':
          'Use a mild cleanser and look for products with salicylic acid to control acne.',
      'isUser': false,
      'timestamp': '9:44',
    },
    {
      'text': 'I have dark spots that won’t fade away.',
      'isUser': true,
      'timestamp': '9:45',
    },
    {
      'text':
          'Use a serum with vitamin C or niacinamide to help brighten and even out your skin tone.',
      'isUser': false,
      'timestamp': '9:46',
    },
  ];

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp':
            '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
      });
      // Add your bot response logic here
    });
    _textController.clear();
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Align(
      alignment:
          message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
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
              message['timestamp'],
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
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                itemCount: _messages.length,
                itemBuilder:
                    (context, index) => _buildMessageBubble(_messages[index]),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.camera_alt, color: Color(0xFFF44336)),
                  //   onPressed: () {
                  //     // Implement image picker functionality
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Color(0xFFF44336)),
                    onPressed: () {
                      // Implement file picker functionality
                      // This could open a file selection dialog
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask Anything',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.history, color: Color(0xFFF44336)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFF44336)),
                    onPressed: () => _sendMessage(_textController.text),
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
