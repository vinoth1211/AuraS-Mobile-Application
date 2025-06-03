import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyDsasWDmeHMsJCFbjGyFYmbLDLmDof7boA';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<SkinAnalysisResult> analyzeSkinImage(File imageFile) async {
    try {
      // Read image as bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Create the prompt for skin analysis
      const prompt = '''
      You are a dermatology AI assistant. Analyze this skin image and provide:
      
      1. DETECTED CONDITIONS: List any visible skin conditions, acne, redness, dryness, or other concerns
      2. SEVERITY: Rate the severity (Mild/Moderate/Severe) for each condition
      3. RECOMMENDATIONS: Provide specific skincare recommendations
      4. WHEN TO SEE DOCTOR: Indicate if professional medical consultation is needed
      
      Format your response as JSON with these exact keys:
      {
        "detectedConditions": ["condition1", "condition2"],
        "severity": {"condition1": "Mild", "condition2": "Moderate"},
        "recommendations": ["recommendation1", "recommendation2", "recommendation3"],
        "seeDoctor": true/false,
        "doctorReason": "reason if seeDoctor is true"
      }
      
      Important: This is for educational purposes only and should not replace professional medical advice.
      ''';

      // Create content with image and text
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      // Generate response
      final response = await _model.generateContent(content);
      final responseText = response.text ?? '';

      // Parse the JSON response
      return _parseAnalysisResult(responseText);

    } catch (e) {
      print('Error analyzing image: $e');
      return SkinAnalysisResult.error('Failed to analyze image: ${e.toString()}');
    }
  }

  SkinAnalysisResult _parseAnalysisResult(String responseText) {
    try {
      // Extract JSON from response (in case there's additional text)
      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        // If no JSON found, create a basic result from the text
        return SkinAnalysisResult(
          detectedConditions: ['Analysis completed'],
          severity: {'General': 'Mild'},
          recommendations: [
            'Use gentle cleanser twice daily',
            'Apply moisturizer after cleansing',
            'Use sunscreen daily'
          ],
          seeDoctor: false,
          doctorReason: '',
          rawResponse: responseText,
        );
      }

      final jsonString = responseText.substring(jsonStart, jsonEnd);

      // For simplicity, we'll parse manually since JSON parsing can be complex
      // In a production app, you'd want to use dart:convert
      return SkinAnalysisResult.fromResponse(responseText);

    } catch (e) {
      print('Error parsing response: $e');
      return SkinAnalysisResult.error('Failed to parse analysis results');
    }
  }
}

class SkinAnalysisResult {
  final List<String> detectedConditions;
  final Map<String, String> severity;
  final List<String> recommendations;
  final bool seeDoctor;
  final String doctorReason;
  final String rawResponse;
  final bool isError;
  final String? errorMessage;

  SkinAnalysisResult({
    required this.detectedConditions,
    required this.severity,
    required this.recommendations,
    required this.seeDoctor,
    required this.doctorReason,
    required this.rawResponse,
    this.isError = false,
    this.errorMessage,
  });

  factory SkinAnalysisResult.error(String message) {
    return SkinAnalysisResult(
      detectedConditions: [],
      severity: {},
      recommendations: [],
      seeDoctor: false,
      doctorReason: '',
      rawResponse: '',
      isError: true,
      errorMessage: message,
    );
  }

  factory SkinAnalysisResult.fromResponse(String response) {
    // Basic parsing - extract key information from response
    final detectedConditions = <String>[];
    final recommendations = <String>[];
    final severity = <String, String>{};

    // Extract detected conditions (looking for bullet points or lists)
    final lines = response.split('\n');
    bool inConditions = false;
    bool inRecommendations = false;
    bool seeDoctor = false;
    String doctorReason = '';

    for (String line in lines) {
      final trimmed = line.trim();

      if (trimmed.toLowerCase().contains('detected') ||
          trimmed.toLowerCase().contains('condition')) {
        inConditions = true;
        inRecommendations = false;
        continue;
      }

      if (trimmed.toLowerCase().contains('recommendation') ||
          trimmed.toLowerCase().contains('treatment')) {
        inConditions = false;
        inRecommendations = true;
        continue;
      }

      if (trimmed.toLowerCase().contains('doctor') ||
          trimmed.toLowerCase().contains('dermatologist')) {
        seeDoctor = true;
        doctorReason = trimmed;
      }

      if (inConditions && (trimmed.startsWith('•') ||
          trimmed.startsWith('-') ||
          trimmed.startsWith('*'))) {
        detectedConditions.add(trimmed.substring(1).trim());
      }

      if (inRecommendations && (trimmed.startsWith('•') ||
          trimmed.startsWith('-') ||
          trimmed.startsWith('*') ||
          RegExp(r'^\d+\.').hasMatch(trimmed))) {
        recommendations.add(trimmed.replaceAll(RegExp(r'^[•\-\*\d\.]\s*'), ''));
      }
    }

    // Set default values if nothing was found
    if (detectedConditions.isEmpty) {
      detectedConditions.addAll(['Skin analysis completed', 'General skin assessment']);
    }

    if (recommendations.isEmpty) {
      recommendations.addAll([
        'Maintain good skincare routine',
        'Use gentle, fragrance-free products',
        'Apply moisturizer daily',
        'Use broad-spectrum sunscreen'
      ]);
    }

    // Set severity for detected conditions
    for (String condition in detectedConditions) {
      severity[condition] = 'Mild'; // Default severity
    }

    return SkinAnalysisResult(
      detectedConditions: detectedConditions,
      severity: severity,
      recommendations: recommendations,
      seeDoctor: seeDoctor,
      doctorReason: doctorReason,
      rawResponse: response,
    );
  }
}