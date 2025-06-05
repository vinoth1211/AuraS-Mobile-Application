import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Import shared widgets
import 'shared_widgets.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final FocusNode _textFieldFocusNode = FocusNode();
  File? _selectedImage;
  bool _isLoading = false;
  bool _quotaExceeded = false;
  bool _isInputFocused = false;

  // Animation controllers
  late AnimationController _floatingAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _shimmerController;
  late AnimationController _breathingController;

  // Animations
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _breathingAnimation;

  static const String apiKey = 'AIzaSyDtuMZVCIfAuZBFLuuZob2O3wjlF1vgxjY';
  late GenerativeModel _textModel;
  late GenerativeModel _visionModel;

  @override
  void initState() {
    super.initState();
    _initializeModels();
    _setupFocusListener();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Floating animation for the chatbot image
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation for send button
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for messages
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Slide animation for input area
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Shimmer animation for loading
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // Breathing animation for AI avatar
    _breathingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _floatingAnimationController.repeat(reverse: true);
    _breathingController.repeat(reverse: true);
    _slideController.forward();
    _fadeController.forward();
  }

  void _initializeModels() {
    _textModel = GenerativeModel(
      model: 'models/gemini-2.0-flash',
      apiKey: apiKey,
    );
    _visionModel = GenerativeModel(
      model: 'models/gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  void _setupFocusListener() {
    _textFieldFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _textFieldFocusNode.hasFocus;
      });

      if (_textFieldFocusNode.hasFocus) {
        _pulseAnimationController.repeat(reverse: true);
      } else {
        _pulseAnimationController.stop();
        _pulseAnimationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _floatingAnimationController.dispose();
    _pulseAnimationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _shimmerController.dispose();
    _breathingController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'Chat Bot'),
            if (_quotaExceeded) _buildModernQuotaWarning(),

            Expanded(
              child: Stack(
                children: [
                  // Gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF8FAFC),
                          Color(0xFFF1F5F9),
                          Color(0xFFE2E8F0),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),

                  // Chat messages area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = _messages.length - 1 - index;
                              return _buildModernMessageBubble(_messages[reversedIndex], index);
                            },
                          ),
                        ),
                        if (!_quotaExceeded && _messages.isEmpty) _buildModernWelcomeCard(),
                        if (!_quotaExceeded) _buildModernQuickActions(),
                        const SizedBox(height: 8),
                        _buildModernInputArea(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Modern floating AI assistant
                  if (_messages.isEmpty)
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_floatingAnimation, _breathingAnimation]),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatingAnimation.value),
                              child: Transform.scale(
                                scale: _breathingAnimation.value,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: _isInputFocused ? 0.3 : 1.0,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6366F1),
                                          Color(0xFF8B5CF6),
                                          Color(0xFFA855F7),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6366F1).withOpacity(0.3),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.smart_toy_outlined,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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

  Widget _buildModernQuotaWarning() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange[100]!,
            Colors.red[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[500],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service Temporarily Unavailable",
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "API quota limits reached. Please contact support for assistance.",
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernWelcomeCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa_outlined, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            "Your AI Skin Care Assistant",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Get personalized skincare advice and analysis from our AI dermatology assistant",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernMessageBubble(Message message, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: value,
            child: _buildMessageBubble(message),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: message.isUser
                      ? const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                      : const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: !message.isUser
                      ? Border.all(color: Colors.grey[200]!, width: 1)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.image != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.file(
                            message.image!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.grey[800],
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (message.isUser) ...[
              const SizedBox(width: 12),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline, color: Colors.grey[600], size: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernQuickActions() {
    final quickQuestions = [
      '✨ Dry skin remedies?',
      '🎯 Acne treatment?',
      '🌟 Fade dark spots?',
      '💧 Sensitive skin care?',
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: quickQuestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 100)),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () => _sendMessage(quickQuestions[index].replaceAll(RegExp(r'[✨🎯🌟💧]\s*'), '')),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          quickQuestions[index],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildModernInputArea() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: _isInputFocused ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
            width: _isInputFocused ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: _selectedImage != null
                    ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                )
                    : null,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _selectedImage != null ? Icons.image : Icons.add_photo_alternate_outlined,
                  color: _selectedImage != null ? Colors.white : const Color(0xFF6366F1),
                  size: 22,
                ),
                onPressed: _quotaExceeded ? null : _pickImage,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _textFieldFocusNode,
                minLines: 1,
                maxLines: 4,
                enabled: !_quotaExceeded,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: _quotaExceeded
                      ? 'Service unavailable'
                      : 'Ask about your skin concerns...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isInputFocused ? _pulseAnimation.value : 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: _isInputFocused
                          ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                          : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: _quotaExceeded || _isLoading
                            ? null
                            : () {
                          if (_messageController.text.isNotEmpty ||
                              _selectedImage != null) {
                            _sendMessage(_messageController.text);
                          }
                        },
                        child: _isLoading
                            ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                            : const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty && _selectedImage == null) return;

    final messageText = text.trim();
    final imageToSend = _selectedImage;

    setState(() {
      _messages.add(
        Message(
          text: messageText.isEmpty && imageToSend != null
              ? "Analyze this skin condition"
              : messageText,
          isUser: true,
          image: imageToSend,
        ),
      );
      _messageController.clear();
      _isLoading = true;
      _selectedImage = null;
    });
    _scrollToBottom();

    try {
      final response = await _getGeminiResponse(messageText, imageToSend);
      if (response != null) {
        setState(() {
          _messages.add(Message(text: response, isUser: false));
          _quotaExceeded = false;
        });
      } else {
        throw Exception('No response received from the AI model');
      }
    } catch (e) {
      final errorMessage = _handleApiError(e);
      setState(() {
        _messages.add(Message(text: errorMessage, isUser: false));
        if (e.toString().contains("quota") ||
            e.toString().contains("billing") ||
            e.toString().contains("exceeded")) {
          _quotaExceeded = true;
        }
      });
      print('Chatbot Error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  String _handleApiError(dynamic error) {
    if (error.toString().contains("quota") ||
        error.toString().contains("billing") ||
        error.toString().contains("exceeded")) {
      return "I'm currently unavailable due to API quota limits. "
          "Please contact support to resolve this issue.";
    } else if (error.toString().contains('API key')) {
      return "Authentication error. Please check API configuration.";
    } else if (error.toString().contains('network')) {
      return "Network error. Please check your internet connection.";
    } else if (error.toString().contains('timeout')) {
      return "Request timed out. Please try again.";
    }
    return "Sorry, something went wrong. Please try again later.";
  }

  Future<String?> _getGeminiResponse(String text, File? image) async {
    const systemPrompt = """
      You are a professional dermatology assistant. When responding to skin concerns:
      1. First, analyze the condition briefly
      2. Then, provide 2-3 recommended treatments
      3. List key ingredients to look for in products
      4. Finally, mention when to see a dermatologist
      
      Keep responses clear, concise, and structured with bullet points.
      If the query is not related to skincare, politely redirect to skincare topics.
    """;

    try {
      if (image != null) {
        final imageBytes = await image.readAsBytes();
        final prompt = """
          $systemPrompt
          
          Analyze this skin condition image. User query: 
          ${text.isEmpty ? "Please analyze this skin condition" : text}
          
          Format your response as follows:
          📝 Analysis...
        """;

        final response = await _visionModel.generateContent([
          Content.multi([
            TextPart(prompt),
            DataPart('image/png', imageBytes),
          ]),
        ]);
        return response.text;
      } else {
        final response = await _textModel.generateContent([
          Content.text('$systemPrompt\n\nUser: $text'),
        ]);
        return response.text;
      }
    } catch (e) {
      throw Exception('Error getting Gemini response: ${e.toString()}');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
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