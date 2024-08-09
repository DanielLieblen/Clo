import 'package:clo/registro/email/confirmacao_email.dart';
import 'package:flutter/material.dart';

class ContinuarRegistroScreen extends StatefulWidget {
  const ContinuarRegistroScreen({super.key});

  @override
  ContinuarRegistroScreenState createState() => ContinuarRegistroScreenState();
}

class ContinuarRegistroScreenState extends State<ContinuarRegistroScreen> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Oculta a AppBar
        backgroundColor: Colors.transparent, // Torna a AppBar transparente
        elevation: 0, // Remove a sombra
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'É um prazer tê-lo conosco',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Continue seu registro e comece',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Por favor digite seu Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Por favor digite seu Sobrenome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (newValue) {
                    setState(() {
                      _termsAccepted = newValue!;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Clicando em Registrar concorda com os termos e condições.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _termsAccepted
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ConfirmacaoEmailScreen(), //passa para a pagina de confirmacao do email
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: _termsAccepted
                    ? const Color(0xFF4A3497)
                    : Colors.grey.shade300, // Cor do botão desativado
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Bordas pouco arredondadas
                ),
              ),
              child: const Text('Finalizar registro'),
            ),
          ],
        ),
      ),
    );
  }
}
