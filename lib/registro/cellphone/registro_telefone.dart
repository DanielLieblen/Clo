import 'package:clo/registro/email/registro_email.dart';
import 'package:flutter/material.dart';

class RegistroTelefoneScreen extends StatefulWidget {
  const RegistroTelefoneScreen({super.key});

  @override
  _RegistroTelefoneScreenState createState() => _RegistroTelefoneScreenState();
}

class _RegistroTelefoneScreenState extends State<RegistroTelefoneScreen> {
  bool _isEmailSelected = false;

  void _toggleSelection() {
    setState(() {
      _isEmailSelected = !_isEmailSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Área de Registro',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Oi, seja bem vindo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isEmailSelected) _toggleSelection();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      backgroundColor: !_isEmailSelected
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                    ),
                    child: Text(
                      'Telefone',
                      style: TextStyle(
                        color: !_isEmailSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_isEmailSelected) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegistroEmailScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      backgroundColor: _isEmailSelected
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                    ),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: _isEmailSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
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
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Enviar código'),
            ),
            const SizedBox(height: 20),
            const Text('ou', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para login com Google
              },
              icon: Image.asset(
                'assets/google_logo.png',
                height: 24.0,
              ),
              label: const Text('Entrar com Google'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                elevation: 2,
                shadowColor: Colors.grey.shade100,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
