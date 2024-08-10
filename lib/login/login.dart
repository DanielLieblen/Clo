import 'package:clo/home/tela_home.dart';
import 'package:clo/registro/email/registro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEmailSelected = true;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  bool _isFormValid = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            _senhaController.text.isNotEmpty &&
            RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text);
      } else {
        _isFormValid = _telefoneController.text.isNotEmpty;
      }
    });
  }

  Future<void> _loginWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Usuário não encontrado.';
      } else if (e.code == 'wrong-password') {
        message = 'Senha incorreta.';
      } else {
        message = 'Ocorreu um erro. Tente novamente.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login com Google: $e')));
    }
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
                onPressed: _loginWithGoogle,
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
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            labelText: 'Senha',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_isPasswordVisible,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isFormValid ? _loginWithEmailAndPassword : null,
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
                  if (_telefoneController.text == '123456789') {
                    // Navegação para a HomeScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    // Mostra mensagem de erro
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Número de telefone inválido')),
                    );
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
