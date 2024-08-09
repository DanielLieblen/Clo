import 'package:clo/registro/email/continuar_registro.dart';
import 'package:clo/registro/telefone/verificar_telefone.dart';
import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool _isEmailSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
            const SizedBox(height: 60), // Aumentando o espaço acima
            const Text(
              'Oi, seja bem vindo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40), // Espaço maior abaixo do título
            _buildSwipeButton(),
            const SizedBox(
                height: 40), // Espaço maior entre o swipe e o formulário
            _isEmailSelected ? _buildEmailForm() : _buildTelefoneForm(),
            const SizedBox(height: 40), // Espaço maior acima do texto "ou"
            const Text('ou', textAlign: TextAlign.center),
            const SizedBox(height: 40), // Espaço maior acima do botão Google
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
            const SizedBox(
                height: 40), // Espaço adicional abaixo do botão Google
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey.shade300,
      ),
      child: Stack(
        children: [
          // Container deslizante
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment:
                _isEmailSelected ? Alignment.centerRight : Alignment.centerLeft,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                setState(() {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    _isEmailSelected = true;
                  } else {
                    _isEmailSelected = false;
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45, // Reduzido
                height: 40, // Reduzido
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Mais arredondado
                  color: Colors.white, // Branco
                ),
                alignment: Alignment.center,
                child: Text(
                  _isEmailSelected ? 'Email' : 'Telefone',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
          // Container com textos fixos fora do deslizante
          Align(
            alignment:
                _isEmailSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              alignment: Alignment.center,
              child: Text(
                _isEmailSelected ? 'Telefone' : 'Email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.grey),
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.grey),
            labelText: 'Senha',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: Icon(Icons.visibility, color: Colors.grey),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContinuarRegistroScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFF4A3497),
          ),
          child: const Text('Registrar-se'),
        ),
      ],
    );
  }

  Widget _buildTelefoneForm() {
    return Column(
      children: [
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerificarTelefoneScreen(),
              ),
            );
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
      ],
    );
  }
}
