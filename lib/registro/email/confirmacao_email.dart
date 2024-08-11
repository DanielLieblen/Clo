import 'package:flutter/material.dart';

class ConfirmacaoEmailScreen extends StatelessWidget {
  const ConfirmacaoEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Oculta a AppBar
        backgroundColor: Colors.transparent, // Torna a AppBar transparente
        elevation: 0, // Remove a sombra
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40), // Adiciona espaço superior
            const Text(
              'Por favor cheque seu email para o link de configuração de conta',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Um link de ativação de conta foi mandado para o seu email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para verificar email ou abrir o app de email
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF4A3497), // Cor do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Bordas completamente retangulares
                ),
              ),
              child: const Text('Verificar Email'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Lógica para reenviar o email
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                    color: Color(0xFF4A3497)), // Borda do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Bordas completamente retangulares
                ),
              ),
              child: const Text(
                'Re-enviar',
                style: TextStyle(color: Color(0xFF4A3497)), // Cor do texto
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Não recebeu o link de ativação?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20), // Adiciona espaço inferior
          ],
        ),
      ),
    );
  }
}
