import 'package:flutter/material.dart';

class ConfirmacaoEmailScreen extends StatelessWidget {
  const ConfirmacaoEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Hides the AppBar
        backgroundColor: Colors.transparent, // Makes the AppBar transparent
        elevation: 0, // Removes the shadow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                // Logic to verify email or go to email app
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Verificar Email'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Logic to resend the email
              },
              child: const Text(
                'Re-enviar',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            const Text(
              'Não recebeu o link de ativação?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for registration
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Logic for entering
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: Colors.deepPurple),
              ),
              child:
                  const Text('Entrar', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Logic for entering with Google
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                elevation: 2,
                shadowColor: Colors.grey.shade100,
              ),
              icon: Image.asset(
                'assets/google_logo.png', // Make sure to have the google logo asset
                height: 24.0,
              ),
              label: const Text(
                'Entrar com Google',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
