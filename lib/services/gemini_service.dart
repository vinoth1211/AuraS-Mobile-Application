import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyDsasWDmeHMsJCFbjGyFYmbLDLmDof7boA';
  late final GenerativeModel _model;
  final int _maxRetries = 2;
  final Duration _timeout = const Duration(seconds: 30);

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3, // Lower for more deterministic responses
        topP: 0.7,
        topK: 20,
      ),
    );
  }

  Future<SkinAnalysisResult> analyzeSkinImage(
      File imageFile, {
        String? userContext,
        int retryCount = 0,
      }) async {
    try {
      // Validate image first
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      if (await imageFile.length() > 5 * 1024 * 1024) {
        throw Exception('Image size exceeds 5MB limit');
      }

      // Read and preprocess image
      final Uint8List imageBytes = await _preprocessImage(imageFile);

      // Enhanced prompt with structured output and context
      final prompt = '''
      **Dermatology Image Analysis Request**
      
      ${userContext != null ? "User Context: $userContext\n" : ""}
      
      Please analyze this skin image carefully and provide:
      
      1. **Detected Conditions**: 
         - List specific skin conditions observed
         - Only include conditions with high confidence
         - Format as ["condition1", "condition2"]
      
      2. **Severity Assessment**:
         - For each condition, assess severity (Mild/Moderate/Severe)
         - Format as {"condition1": "Severity", "condition2": "Severity"}
      
      3. **Recommendations**:
         - Provide 3-5 specific, actionable recommendations
         - Include product types when appropriate
         - Format as ["recommendation1", "recommendation2"]
      
      4. **Medical Consultation**:
         - "seeDoctor": true/false based on condition severity
         - "doctorReason": Brief explanation if true
      
      **Response Requirements**:
      - Must be valid JSON format only
      - No additional text outside JSON
      - Use this exact structure:
      {
        "detectedConditions": [],
        "severity": {},
        "recommendations": [],
        "seeDoctor": false,
        "doctorReason": "",
        "confidenceScore": 0-100
      }
      
      **Important Notes**:
      - Be conservative in diagnoses
      - When uncertain, recommend consultation
      - This is for educational purposes only
      ''';

      // Generate content with retry logic
      final response = await _generateContentWithRetry(
        imageBytes,
        prompt,
        retryCount,
      );

      // Parse and validate response
      return _parseAnalysisResult(response);
    } catch (e) {
      print('Error analyzing image: $e');
      return SkinAnalysisResult.error(
        'Failed to analyze image: ${e.toString()}',
        rawResponse: e.toString(),
      );
    }
  }

  Future<Uint8List> _preprocessImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      // Here you could add actual image preprocessing:
      // - Resize to optimal dimensions
      // - Normalize lighting/contrast
      // - Convert to consistent format
      return bytes;
    } catch (e) {
      print('Image preprocessing error: $e');
      throw Exception('Failed to process image');
    }
  }

  Future<String> _generateContentWithRetry(
      Uint8List imageBytes,
      String prompt,
      int retryCount,
      ) async {
    try {
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _model.generateContent(content)
          .timeout(_timeout);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from API');
      }

      return response.text!;
    } catch (e) {
      if (retryCount < _maxRetries) {
        // Exponential backoff
        await Future.delayed(Duration(seconds: 1 * (retryCount + 1)));
        return _generateContentWithRetry(imageBytes, prompt, retryCount + 1);
      }
      rethrow;
    }
  }

  SkinAnalysisResult _parseAnalysisResult(String responseText) {
    try {
      // Clean the response text
      String cleanedResponse = responseText.trim();

      // Remove markdown code blocks if present
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(0, cleanedResponse.length - 3);
      }

      // Parse JSON
      final jsonMap = jsonDecode(cleanedResponse) as Map<String, dynamic>;

      // Validate and extract data
      final conditions = List<String>.from(jsonMap['detectedConditions'] ?? []);
      final severity = Map<String, String>.from(jsonMap['severity'] ?? {});
      final recommendations = List<String>.from(jsonMap['recommendations'] ?? []);
      final seeDoctor = jsonMap['seeDoctor'] as bool? ?? false;
      final doctorReason = jsonMap['doctorReason'] as String? ?? '';
      final confidenceScore = jsonMap['confidenceScore'] as int? ?? 0;

      // Validate severity matches conditions
      for (final condition in conditions) {
        if (!severity.containsKey(condition)) {
          severity[condition] = 'Mild';
        }
      }

      // Ensure we have at least basic recommendations
      if (recommendations.isEmpty) {
        recommendations.addAll([
          'Use gentle, fragrance-free cleanser',
          'Apply moisturizer daily',
          'Use broad-spectrum sunscreen SPF 30+'
        ]);
      }

      return SkinAnalysisResult(
        detectedConditions: conditions,
        severity: severity,
        recommendations: recommendations,
        seeDoctor: seeDoctor,
        doctorReason: doctorReason,
        confidenceScore: confidenceScore,
        rawResponse: responseText,
      );
    } catch (e) {
      print('Error parsing response: $e\nResponse: $responseText');
      return SkinAnalysisResult.error(
        'Failed to parse analysis results',
        rawResponse: responseText,
      );
    }
  }
}

class SkinAnalysisResult {
  final List<String> detectedConditions;
  final Map<String, String> severity;
  final List<String> recommendations;
  final bool seeDoctor;
  final String doctorReason;
  final int confidenceScore;
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
    this.confidenceScore = 0,
    this.isError = false,
    this.errorMessage,
  });

  factory SkinAnalysisResult.error(String message, {String rawResponse = ''}) {
    return SkinAnalysisResult(
      detectedConditions: [],
      severity: {},
      recommendations: [],
      seeDoctor: false,
      doctorReason: '',
      rawResponse: rawResponse,
      isError: true,
      errorMessage: message,
    );
  }

  // Helper method to get severity color for UI
  Color getSeverityColor(String condition) {
    final severityLevel = severity[condition]?.toLowerCase() ?? 'mild';
    switch (severityLevel) {
      case 'severe':
        return const Color(0xFFEF5350);
      case 'moderate':
        return const Color(0xFFFF9800);
      case 'mild':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  // Confidence level description
  String get confidenceLevel {
    if (confidenceScore > 75) return 'High Confidence';
    if (confidenceScore > 50) return 'Moderate Confidence';
    if (confidenceScore > 25) return 'Low Confidence';
    return 'Very Low Confidence';
  }
}