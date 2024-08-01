import 'package:flutter/material.dart';
import 'package:clo/registro/registro_email.dart';

class RegistroTelefoneScreen extends StatelessWidget {
  const RegistroTelefoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área de Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Toggle de Telefone e Email (simulado com texto por simplicidade)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Telefone')),
                OutlinedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroEmailScreen()),
                  );
                }, child: const Text('Email')),
              ],
            ),
            const SizedBox(height: 20),
            // Campo para número de telefone
            const TextField(
              decoration: InputDecoration(
                labelText: 'Número de Telefone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar código de verificação
              },
              child: const Text('Enviar código'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Botão de largura cheia
              ),
            ),
            const SizedBox(height: 20),
            const Text('ou'),
            const SizedBox(height: 20),
            // Botão de login com Google
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para login com Google
              },
              icon: const Icon(Icons.email),
              label: const Text('Entrar com Google'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
