import 'package:clo/registro/email/continuar_registro.dart';
import 'package:flutter/material.dart';

class RegistroEmailScreen extends StatefulWidget {
  const RegistroEmailScreen({super.key});

  @override
  _RegistroEmailScreenState createState() => _RegistroEmailScreenState();
}

class _RegistroEmailScreenState extends State<RegistroEmailScreen> {
  bool _isEmailSelected = true;

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
                      if (!_isEmailSelected) _toggleSelection();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isEmailSelected) _toggleSelection();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
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
              ],
            ),
            const SizedBox(height: 20),
            if (_isEmailSelected)
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              )
            else
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Senha',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContinuarRegistroScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Registrar-se'),
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
