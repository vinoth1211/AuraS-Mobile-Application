import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const apiKey = 'AIzaSyDtuMZVCIfAuZBFLuuZob2O3wjlF1vgxjY';
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1/models?key=$apiKey',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Available Gemini models:');
      for (final model in data['models']) {
        print(
          '- [32m${model['name']}[0m (description: ${model['description']})',
        );
      }
    } else {
      print(
        'Failed to list models. Status code: [31m${response.statusCode}[0m',
      );
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error listing models: $e');
  }
}
