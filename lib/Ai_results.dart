import 'dart:io';
import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'services/gemini_service.dart';
import 'DoctorChannelingScreen.dart';

class AIAnalysisResultScreen extends StatefulWidget {
  final File imageFile;
  final String? userDescription;

  const AIAnalysisResultScreen({
    super.key,
    required this.imageFile,
    this.userDescription,
  });

  @override
  State<AIAnalysisResultScreen> createState() => _AIAnalysisResultScreenState();
}

class _AIAnalysisResultScreenState extends State<AIAnalysisResultScreen> {
  final GeminiService _geminiService = GeminiService();
  SkinAnalysisResult? _analysisResult;
  bool _isAnalyzing = true;
  String? _errorMessage;
  int _analysisAttempts = 0;
  final int _maxRetries = 2;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    if (_analysisAttempts >= _maxRetries) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'Maximum analysis attempts reached. Please try again later.';
      });
      return;
    }

    try {
      setState(() {
        _isAnalyzing = true;
        _errorMessage = null;
        _analysisAttempts++;
      });

      final result = await _geminiService.analyzeSkinImage(
        widget.imageFile,
        userContext: widget.userDescription,
        retryCount: _analysisAttempts - 1,
      );

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

        if (_analysisAttempts < _maxRetries && e.toString().contains('timeout')) {
          Future.delayed(const Duration(seconds: 2), _analyzeImage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis Results'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Image Display
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  widget.imageFile,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Analysis Status
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
                    child: OutlinedButton(
                      onPressed: _isAnalyzing ? null : _analyzeImage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Re-analyze",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Done",
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
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 20),
          Text(
            "Analyzing your skin image...",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Attempt $_analysisAttempts of $_maxRetries",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[400],
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            "Analysis Failed",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? "Unknown error occurred",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_analysisAttempts < _maxRetries) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
              ),
              child: const Text("Try Again"),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final result = _analysisResult!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Confidence Indicator
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.blue[600],
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analysis Confidence: ${result.confidenceScore}%",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: result.confidenceScore / 100,
                      backgroundColor: Colors.grey[300],
                      color: result.confidenceScore > 75
                          ? Colors.green
                          : result.confidenceScore > 50
                          ? Colors.orange
                          : Colors.red,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.confidenceLevel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Detected Conditions
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Detected Conditions",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (result.detectedConditions.isEmpty)
                  Text(
                    "No specific conditions detected",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else
                  ...result.detectedConditions.map((condition) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: result.getSeverityColor(condition),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                condition,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (result.severity.containsKey(condition))
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: result
                                          .getSeverityColor(condition)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                        result.getSeverityColor(condition),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      result.severity[condition]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                        color:
                                        result.getSeverityColor(condition),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Recommendations
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Recommendations",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.recommendations.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${entry.key + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),

        // Doctor Consultation Warning
        if (result.seeDoctor) ...[
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.orange[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.orange[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.orange[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Medical Consultation Recommended",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.doctorReason.isNotEmpty
                        ? result.doctorReason
                        : "Based on the analysis, we recommend consulting with a dermatologist for professional evaluation.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Doctor Channeling Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorChannelingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Find a Dermatologist"),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Disclaimer
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "⚠️ This analysis is for educational purposes only and should not replace professional medical advice. Always consult with a healthcare professional for proper diagnosis and treatment.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
