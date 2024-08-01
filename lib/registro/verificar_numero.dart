import 'package:flutter/material.dart';

class VerificarNumeroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificação em Duas Etapas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustração ou imagem de verificação
            Image.asset(
              'assets/verification.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Entre com o número',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Um código de verificação foi enviado para o seu número',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Campos para inserir o código de verificação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeBox(),
                _buildCodeBox(),
                _buildCodeBox(),
                _buildCodeBox(),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para verificar o código
              },
              child: const Text('Verificar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Botão de largura cheia
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para criar as caixas de inserção do código
  Widget _buildCodeBox() {
    return const SizedBox(
      width: 50,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
      ),
    );
  }
}
