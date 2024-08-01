import 'package:clo/registro/verificar_numero.dart';
import 'package:flutter/material.dart';

class ContinuarRegistroScreen extends StatelessWidget {
  const ContinuarRegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continuar registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'É um prazer tê-lo conosco',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Campo para nome
            const TextField(
              decoration: InputDecoration(
                labelText: 'Por favor, digite seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para sobrenome
            const TextField(
              decoration: InputDecoration(
                labelText: 'Por favor, digite seu sobrenome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (newValue) {
                    // Lógica para alterar o estado do checkbox
                  },
                ),
                const Text('Aceito os termos e condições'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerificarNumeroScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(double.infinity, 50), // Botão de largura cheia
              ),
              child: const Text('Finalizar registro'),
            ),
          ],
        ),
      ),
    );
  }
}
