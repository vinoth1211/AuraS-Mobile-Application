import 'dart:io';
import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'services/gemini_service.dart';

class AIAnalysisResultScreen extends StatefulWidget {
  final File imageFile;

  const AIAnalysisResultScreen({super.key, required this.imageFile});

  @override
  State<AIAnalysisResultScreen> createState() => _AIAnalysisResultScreenState();
}

class _AIAnalysisResultScreenState extends State<AIAnalysisResultScreen> {
  final GeminiService _geminiService = GeminiService();
  SkinAnalysisResult? _analysisResult;
  bool _isAnalyzing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    try {
      setState(() {
        _isAnalyzing = true;
        _errorMessage = null;
      });

      final result = await _geminiService.analyzeSkinImage(widget.imageFile);

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
        if (result.isError) {
          _errorMessage = result.errorMessage;
        }
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'Failed to analyze image: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            const CustomNavigationBar(activeRoute: 'AI Analysis'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Image Display
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        widget.imageFile,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Analysis Results
                    if (_isAnalyzing)
                      _buildLoadingWidget()
                    else if (_errorMessage != null)
                      _buildErrorWidget()
                    else if (_analysisResult != null)
                        _buildAnalysisResults(),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isAnalyzing ? null : () {
                              _analyzeImage(); // Retry analysis
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Re-analyze",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDF4F5C),
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Back",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
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
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDF4F5C)),
          ),
          SizedBox(height: 16),
          Text(
            "Analyzing your skin image...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "This may take a few moments",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEF5350)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFEF5350),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            "Analysis Failed",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF5350),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? "Unknown error occurred",
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final result = _analysisResult!;

    return Column(
      children: [
        // Detected Conditions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.search, color: Color(0xFFDF4F5C)),
                  SizedBox(width: 8),
                  Text(
                    "Detected Conditions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (result.detectedConditions.isEmpty)
                const Text("No specific conditions detected")
              else
                ...result.detectedConditions.map((condition) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDF4F5C),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          condition,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (result.severity.containsKey(condition))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(result.severity[condition]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            result.severity[condition]!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                )),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Recommendations
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Color(0xFF4CAF50)),
                  SizedBox(width: 8),
                  Text(
                    "Recommendations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...result.recommendations.asMap().entries.map((entry) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key + 1}.",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),

        // Doctor Consultation Warning
        if (result.seeDoctor) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF9800)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Color(0xFFFF9800)),
                    SizedBox(width: 8),
                    Text(
                      "Medical Consultation Recommended",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.doctorReason.isNotEmpty
                      ? result.doctorReason
                      : "Consider consulting with a dermatologist for professional evaluation and treatment.",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],

        // Disclaimer
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "⚠️ This analysis is for educational purposes only and should not replace professional medical advice. Always consult with a healthcare professional for proper diagnosis and treatment.",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
        return const Color(0xFF4CAF50);
      case 'moderate':
        return const Color(0xFFFF9800);
      case 'severe':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}