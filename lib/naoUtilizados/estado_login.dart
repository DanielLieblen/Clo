import 'package:flutter/material.dart';

class EstadoLoginScreen extends StatefulWidget {
  const EstadoLoginScreen({super.key});

  @override
  _EstadoLoginScreenState createState() => _EstadoLoginScreenState();
}

class _EstadoLoginScreenState extends State<EstadoLoginScreen> {
  bool _isEmail = true; // Inicialmente, o campo é de e-mail

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _isEmail,
                  onChanged: (value) {
                    setState(() {
                      _isEmail = value!;
                    });
                  },
                ),
                const Text('Usar email'),
              ],
            ),
            TextField(
              keyboardType:
                  _isEmail ? TextInputType.emailAddress : TextInputType.phone,
              decoration: InputDecoration(
                labelText: _isEmail ? 'Email' : 'Telefone',
              ),
            ),
            // ... outros elementos da tela
          ],
        ),
      ),
    );
  }
}
