import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'shared_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AISkinAnalysisScreen extends StatefulWidget {
  const AISkinAnalysisScreen({super.key});

  @override
  State<AISkinAnalysisScreen> createState() => _AISkinAnalysisScreenState();
}

class _AISkinAnalysisScreenState extends State<AISkinAnalysisScreen> {
  final ImagePicker _picker = ImagePicker();

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.red),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final status = await Permission.camera.request();
                  if (status.isGranted) {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      _navigateToImageAnalysis(File(pickedFile.path));
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.red),
                title: const Text("Upload Image"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    _navigateToImageAnalysis(File(pickedFile.path));
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToImageAnalysis(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageAnalysisScreen(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'AI Analysis'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/ai_face.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE2A7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "AI Skin Analysis",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/ai_icon.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      "AuraS scans, analyses, and alerts you to potential issues before they become serious",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFDF4F5C),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Upload a photo of your skin concern, and let our AI analyze it to provide personalized insights and possible solutions.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _showImageSourceOptions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Analysis',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageAnalysisScreen extends StatefulWidget {
  final File image;

  const ImageAnalysisScreen({super.key, required this.image});

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  bool _isAnalyzing = false;
  String? _analysisResult;

  // Replace with your actual Gemini API key
  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String _geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$_geminiApiKey';

  Future<void> _analyzeImage() async {
    try {
      setState(() {
        _isAnalyzing = true;
        _analysisResult = null;
      });

      // Read image bytes
      final bytes = await widget.image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Prepare the request payload
      final requestBody = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Analyze this skin image and provide a detailed report about potential skin conditions, concerns, and recommendations. Focus on dermatological accuracy and provide actionable insights.",
              },
              {
                "inline_data": {"mime_type": "image/jpeg", "data": base64Image},
              },
            ],
          },
        ],
      });

      // Make the API call
      final response = await http.post(
        Uri.parse(_geminiApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _analysisResult =
              responseData['candidates'][0]['content']['parts'][0]['text'];
        });
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error analyzing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to analyze image. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Start analysis automatically when screen loads
    _analyzeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the selected image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(widget.image, height: 300, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),

              // Analysis status/result
              if (_isAnalyzing)
                const Column(
                  children: [
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Analyzing your skin...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              else if (_analysisResult != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Analysis Results:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(_analysisResult!),
                  ],
                ),

              // Retry button if analysis failed
              if (!_isAnalyzing && _analysisResult == null)
                Column(
                  children: [
                    const Text('Analysis failed'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _analyzeImage,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
