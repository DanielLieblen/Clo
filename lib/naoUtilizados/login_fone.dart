import 'package:flutter/material.dart';

class LoginPhoneScreen extends StatelessWidget {
  const LoginPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área de Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Implementar a lógica para voltar à tela anterior
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Olá, seja bem vindo'),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefone',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementar a lógica de login por telefone
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            const Text('ou'),
            IconButton(
              icon: Image.asset('assets/google_logo.png'), // Substitua pelo caminho correto do seu logo
              onPressed: () {
                // Implementar a lógica de login com Google
              },
            ),
            const SizedBox(height: 10),
            const Text('Não está registrado? Crie uma conta.'),
          ],
        ),
      ),
    );
  }
}
