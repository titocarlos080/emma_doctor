import 'package:flutter/material.dart';

import '../services/services.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TextEditingController _textController;
  String _response = ''; // Campo para almacenar la respuesta de GPT
  bool _isLoading = false; // Para mostrar un indicador de carga

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    setState(() {
      _isLoading = true; // Mostrar el indicador de carga
    });

    GptService gptService = GptService();
    String prompt = _textController.text; // El mensaje que quieres enviar a GPT
   
      print("Este es el msj que se esta mandando: $prompt");
    
    try {
      String response = await gptService.sendMessage(prompt); // Consumir la API de GPT
      setState(() {
        _response = response; // Actualizar la respuesta en la interfaz
        _isLoading = false; // Ocultar el indicador de carga
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with GPT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()), // Indicador de carga
                    if (_response.isNotEmpty) ...[
                      const Text(
                        'Respuesta de GPT:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_response),
                    ],
                  ],
                ),
              ),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Escribe tu mensaje...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendMessage, // Llama a la función para enviar el mensaje
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
