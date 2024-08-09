// Certifique-se de que o caminho está correto
import 'package:clo/registro/email/registro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEmailSelected = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _senhaController.addListener(_validateForm);
    _telefoneController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      if (_isEmailSelected) {
        _isFormValid = _emailController.text.isNotEmpty &&
            _senhaController.text.isNotEmpty;
      } else {
        _isFormValid = _telefoneController.text.isNotEmpty;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

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
          'Área de Login',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Oi, bem vindo de volta à sua conta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _buildSwipeButton(),
              const SizedBox(height: 40),
              _isEmailSelected ? _buildEmailForm() : _buildTelefoneForm(),
              const SizedBox(height: 40),
              const Text('ou', textAlign: TextAlign.center),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Lógica para login com Google
                  if (kDebugMode) {
                    print("Login com Google");
                  }
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
              const SizedBox(height: 20),
              _buildCreateAccountOption(),
            ],
          ),
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
          Align(
            alignment:
                _isEmailSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              alignment: Alignment.center,
              child: Text(
                _isEmailSelected ? 'Telefone' : 'Email',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
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
                  _validateForm();
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  _isEmailSelected ? 'Email' : 'Telefone',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
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
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
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
        TextField(
          controller: _senhaController,
          decoration: const InputDecoration(
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
          onPressed: _isFormValid
              ? () {
                  // Lógica de login com email
                  if (kDebugMode) {
                    print("Login com email: ${_emailController.text}");
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor:
                _isFormValid ? const Color(0xFF4A3497) : Colors.grey.shade300,
          ),
          child: const Text('Entrar'),
        ),
      ],
    );
  }

  Widget _buildTelefoneForm() {
    return Column(
      children: [
        TextField(
          controller: _telefoneController,
          decoration: const InputDecoration(
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
          onPressed: _isFormValid
              ? () {
                  // Lógica de login com telefone
                  if (kDebugMode) {
                    print("Login com telefone: ${_telefoneController.text}");
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor:
                _isFormValid ? const Color(0xFF4A3497) : Colors.grey.shade300,
          ),
          child: const Text('Entrar'),
        ),
      ],
    );
  }

  Widget _buildCreateAccountOption() {
    return GestureDetector(
      onTap: () {
        // Redirecionando para a tela de registro
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistroScreen(),
          ),
        );
      },
      child: const Text(
        'Não está registrado? Crie uma conta.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.orange, fontSize: 16),
      ),
    );
  }
}
