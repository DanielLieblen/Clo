import 'package:flutter/material.dart';
import 'package:clo/registro/continuar_registro.dart';

class RegistroEmailScreen extends StatelessWidget {
  const RegistroEmailScreen({super.key});

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
            // Toggle de Telefone e Email
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(onPressed: () {
                  Navigator.pop(context);
                }, child: const Text('Telefone')),
                ElevatedButton(onPressed: () {}, child: const Text('Email')),
              ],
            ),
            const SizedBox(height: 20),
            // Campo para email
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Campo para senha
            const TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContinuarRegistroScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Botão de largura cheia
              ),
              child: const Text('Registrar-se'),
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
                foregroundColor: Colors.black, backgroundColor: Colors.white, minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
