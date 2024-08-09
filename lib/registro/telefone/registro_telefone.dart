import 'package:clo/registro/email/registro_email.dart';
import 'package:flutter/material.dart';

class RegistroTelefoneScreen extends StatefulWidget {
  const RegistroTelefoneScreen({super.key});

  @override
  _RegistroTelefoneScreenState createState() => _RegistroTelefoneScreenState();
}

class _RegistroTelefoneScreenState extends State<RegistroTelefoneScreen> {
  bool _isEmailSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3497)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Área de Registro',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                      if (_isEmailSelected) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistroScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      backgroundColor: !_isEmailSelected
                          ? const Color(0xFF4A3497)
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
                        setState(() {
                          _isEmailSelected = true;
                        });
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
                          ? const Color(0xFF4A3497)
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
                prefixIcon: Icon(Icons.phone, color: Colors.grey),
                labelText: 'Número de Telefone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a próxima tela
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF4A3497),
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
                width: 24.0,
              ),
              label: const Text('Entrar com Google'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                elevation: 2,
                shadowColor: Colors.grey.shade100,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
