import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificarTelefoneScreen extends StatefulWidget {
  const VerificarTelefoneScreen({super.key});

  @override
  _VerificarTelefoneScreenState createState() =>
      _VerificarTelefoneScreenState();
}

class _VerificarTelefoneScreenState extends State<VerificarTelefoneScreen> {
  final _codigoController = TextEditingController();
  String? _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _auth.currentUser?.phoneNumber ?? '',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _saveAdditionalInfo();
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha na verificação: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar telefone: $e')),
      );
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codigoController.text,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Salvar informações adicionais no Firestore
      _saveAdditionalInfo();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telefone verificado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar código: $e')),
      );
    }
  }

  Future<void> _saveAdditionalInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Salvar mais informações no Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'phone_number': user.phoneNumber,
        'created_at': Timestamp.now(),
      });

      // Você pode salvar mais informações conforme necessário
    }
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
          'Verificação em Duas Etapas',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/verification_image.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Entre com o número',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Um código com 4 dígitos foi enviado para\n+55 7874013717',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signInWithPhoneNumber();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF4A3497),
                ),
                child: const Text('Verificar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
