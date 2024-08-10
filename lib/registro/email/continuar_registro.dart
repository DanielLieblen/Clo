import 'package:clo/login/login.dart';
import 'package:clo/registro/email/confirmacao_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContinuarRegistroScreen extends StatefulWidget {
  const ContinuarRegistroScreen(
      {super.key, required String email, required String password});

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

  // Função para verificar se o e-mail já existe no Firestore
  Future<bool> _emailAlreadyExists(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _saveAdditionalInfo() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      try {
        User? user = _auth.currentUser;

        if (user != null) {
          // Verifica se o e-mail já existe no Firestore
          bool emailExists = await _emailAlreadyExists(user.email!);

          if (emailExists) {
            // Se o e-mail já existe, mostrar mensagem e redirecionar para a tela de login
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

          // Se a conta não existir, continue com o registro
          await user.updateDisplayName(
              "${_nomeController.text} ${_sobrenomeController.text}");

          // Armazena informações adicionais no Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'first_name': _nomeController.text,
            'last_name': _sobrenomeController.text,
            'email': user.email,
            'created_at': Timestamp.now(),
          });

          // Enviar email de verificação
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
                onPressed: _termsAccepted
                    ? _saveAdditionalInfo
                    : null, // Passa diretamente a função para ser executada quando o botão for pressionado
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
