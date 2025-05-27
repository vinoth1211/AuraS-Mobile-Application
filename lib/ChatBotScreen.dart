// import 'package:flutter/material.dart';
// import 'package:skincare_app/shared_widgets.dart';

// class ChatBotScreen extends StatelessWidget {
//   const ChatBotScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomHeader(),
//             const CustomNavigationBar(activeRoute: 'Chat Bot'),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Add your blog content here
//                     const Center(child: Text('Chat Bot Screen Content')),
//                     // Add more blog components below
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'shared_widgets.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  // Add your Gemini API Key here
  static const String apiKey = 'AIzaSyCwVJK5hr_6zau7pKfS0HNeOicw1e9tAvI';
  final GenerativeModel _textModel = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );
  final GenerativeModel _visionModel = GenerativeModel(
    model: 'gemini-pro-vision',
    apiKey: apiKey,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      body: Column(
        children: [
          const CustomNavigationBar(activeRoute: 'Chat Bot'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
                  ),
                  _buildQuickActions(),
                  _buildInputArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser 
              ? const Color(0xFFE94057).withOpacity(0.1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.image != null)
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(message.image!),
                    fit: BoxFit.cover,
                  ),
                ),
            const SizedBox(height: 8),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? const Color(0xFFE94057) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final quickQuestions = [
      'I have dry and flaky skin on my face',
      'I’m getting frequent breakouts on my cheeks',
      'I have dark spots that won’t fade away',
    ];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickQuestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE94057).withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            onPressed: () => _sendMessage(quickQuestions[index]),
            child: Text(
              quickQuestions[index],
              style: const TextStyle(color: Color(0xFFE94057)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add_photo_alternate, 
                     color: _selectedImage != null 
                         ? const Color(0xFFE94057) 
                         : Colors.grey),
          onPressed: _pickImage,
        ),
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Ask anything...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          icon: _isLoading
              ? const CircularProgressIndicator()
              : const Icon(Icons.send, color: Color(0xFFE94057)),
          onPressed: _isLoading ? null : () {
            if (_messageController.text.isNotEmpty || _selectedImage != null) {
              _sendMessage(_messageController.text);
            }
          },
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    setState(() {
      _messages.add(Message(
        text: text,
        isUser: true,
        image: _selectedImage,
      ));
      _messageController.clear();
      _isLoading = true;
      _selectedImage = null;
    });
    _scrollToBottom();

    try {
      final response = await _getGeminiResponse(text);
      setState(() {
        _messages.add(Message(
          text: response ?? 'Sorry, I couldn\'t process your request',
          isUser: false,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    _scrollToBottom();
  }

  Future<String?> _getGeminiResponse(String text) async {
    if (_selectedImage != null) {
      final imageBytes = await _selectedImage!.readAsBytes();
      final prompt = TextPart("""
        Analyze this skin condition and provide professional skincare advice.
        The user says: $text
        Provide detailed recommendations including:
        - Possible condition diagnosis
        - Recommended skincare routine
        - Product ingredients to look for
        - When to see a dermatologist
      """);
      
      final response = await _visionModel.generateContent([
        Content.multi([prompt, DataPart('image/jpeg', imageBytes)])
      ]);
      return response.text;
    } else {
      const systemPrompt = """
        You are a professional dermatology assistant. Provide detailed, 
        scientific skincare advice. Include:
        - Possible causes
        - Recommended treatments
        - Prevention tips
        - When to see a professional
        Use medical terminology but explain clearly.
      """;
      
      final response = await _textModel.generateContent([
        Content.text('$systemPrompt\nUser: $text')
      ]);
      return response.text;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class Message {
  final String text;
  final bool isUser;
  final File? image;

  Message({
    required this.text,
    required this.isUser,
    this.image,
  });
}