import 'package:clo/login/login.dart';
import 'package:clo/registro/email/confirmacao_email.dart'; // Importe a tela de confirmação de email
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContinuarRegistroScreen extends StatefulWidget {
  final String email;
  final String password;

  const ContinuarRegistroScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ContinuarRegistroScreenState createState() => ContinuarRegistroScreenState();
}

class ContinuarRegistroScreenState extends State<ContinuarRegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  bool _termsAccepted = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveAdditionalInfo() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      try {
        // Realiza o login com o email e senha registrados anteriormente
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

        User? user = userCredential.user;

        if (user != null) {
          // Verifica se o e-mail já existe no Firestore
          final querySnapshot = await _firestore
              .collection('users')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Conta já existe. Redirecionando para login.')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            return;
          }

          // Atualiza o display name do usuário
          await user.updateDisplayName(
              "${_nomeController.text} ${_sobrenomeController.text}");

          // Salva as informações adicionais no Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'first_name': _nomeController.text,
            'last_name': _sobrenomeController.text,
            'email': user.email,
            'created_at': Timestamp.now(),
          });

          // Envia email de verificação
          await user.sendEmailVerification();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Perfil atualizado com sucesso! Verifique seu email.')),
          );

          // Redireciona para a tela de confirmação de email
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfirmacaoEmailScreen(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Aceite os termos e preencha o formulário corretamente.')),
      );
    }
  }

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
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Por favor digite seu Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _sobrenomeController,
                decoration: const InputDecoration(
                  labelText: 'Por favor digite seu Sobrenome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu sobrenome';
                  }
                  return null;
                },
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
                onPressed: _termsAccepted ? _saveAdditionalInfo : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: _termsAccepted
                      ? const Color(0xFF4A3497)
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Finalizar registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
