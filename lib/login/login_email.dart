// registration_page.dart

import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para processar o registro
              },
              child: Text('SIGN UP'),
            ),
            Image.asset('assets/google_logo.png'), // Seu logotipo do Google
          ],
        ),
      ),
    );
  }
}
