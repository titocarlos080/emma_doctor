 import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GptService {
  // Obtén la API Key desde el archivo .env o una fuente segura
final String _apiKey = dotenv.env['API_KEY'] ?? 'No API Key found';
  final String _apiUrl = "https://api.openai.com/v1/chat/completions"; // URL de la API de OpenAI para chat

  // Método para enviar un mensaje y obtener una respuesta del modelo GPT
  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini', // O puedes usar 'gpt-4' si tienes acceso a ese modelo
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': message}
          ],
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String reply = responseData['choices'][0]['message']['content'];
        return reply.trim(); // Devuelve la respuesta generada
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}

// Función para probar el servicio GPT
Future<void> testGptService(String prompt) async {
  GptService gptService = GptService();
  print("Enviando mensaje a GPT: $prompt");

  try {
    String response = await gptService.sendMessage(prompt);
    print("Respuesta de GPT: $response");
  } catch (e) {
    print("Ocurrió un error: $e");
  }
}

Future<void> main(List<String> args) async {
  print("Hola");

  GptService gptService = GptService();
  String response = await gptService.sendMessage("Hola, ¿cómo estás?");
  
  print(response); // No es necesario usar toString(), ya es un String
}
