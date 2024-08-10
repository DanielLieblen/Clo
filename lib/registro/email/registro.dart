import 'package:clo/home/tela_home.dart'; // Certifique-se de que o caminho está correto
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool _isEmailSelected = true;
  bool _showAdditionalFields = false;
  bool _isFormValid = false;
  bool _termsAccepted = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController =
      TextEditingController(text: '+55'); // Pré-preenche com +55
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _senhaController.addListener(_validateForm);
    _telefoneController.addListener(_validateForm);
    _nomeController.addListener(_validateForm);
    _sobrenomeController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      if (_isEmailSelected) {
        _isFormValid = _isValidEmail(_emailController.text) &&
            _isValidSenha(_senhaController.text);
      } else {
        _isFormValid = _isValidTelefone(_telefoneController.text);
      }

      if (_showAdditionalFields) {
        _isFormValid = _isFormValid &&
            _nomeController.text.isNotEmpty &&
            _sobrenomeController.text.isNotEmpty &&
            _termsAccepted;
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  bool _isValidSenha(String senha) {
    return senha.length >= 6;
  }

  bool _isValidTelefone(String telefone) {
    // Verifica se o telefone começa com + e contém apenas dígitos depois
    return RegExp(r'^\+\d{10,15}$').hasMatch(telefone);
  }

  Future<void> _registrarComEmail() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      // Sucesso no registro, exibir campos adicionais
      setState(() {
        _showAdditionalFields = true;
      });
    } on FirebaseAuthException catch (e) {
      // Tratar erro
      String message;
      if (e.code == 'weak-password') {
        message = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Uma conta já existe para este email.';
      } else {
        message = 'Ocorreu um erro. Tente novamente.';
      }
      _mostrarErro(message);
    }
  }

  Future<void> _registrarComTelefone() async {
    final String telefoneFormatado = _telefoneController.text.trim();

    if (!_isValidTelefone(telefoneFormatado)) {
      _mostrarErro(
          'Por favor, insira o número de telefone no formato correto E.164, como +5511998765432.');
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: telefoneFormatado,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolve for some devices
          await _auth.signInWithCredential(credential);
          setState(() {
            _showAdditionalFields = true;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          _mostrarErro('Falha ao verificar o número: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Código de verificação enviado.'),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      _mostrarErro('Erro: $e');
    }
  }

  Future<void> _verificarCodigoSMS() async {
    try {
      final code = _smsCodeController.text.trim();
      if (_verificationId != null && code.isNotEmpty) {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: code,
        );
        await _auth.signInWithCredential(credential);
        setState(() {
          _showAdditionalFields = true;
        });

        // Redireciona para a tela home após a verificação
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _mostrarErro('Código de verificação inválido.');
      }
    } catch (e) {
      _mostrarErro('Erro ao verificar código: $e');
    }
  }

  Future<void> _salvarInformacoesAdicionais() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Se a conta não existir, continue com o registro
        await user.updateDisplayName(
            "${_nomeController.text} ${_sobrenomeController.text}");

        // Armazena informações adicionais no Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'first_name': _nomeController.text,
          'last_name': _sobrenomeController.text,
          'email': user.email ?? user.phoneNumber,
          'created_at': Timestamp.now(),
        });

        // Enviar email de verificação se for email
        if (_isEmailSelected) {
          await user.sendEmailVerification();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Perfil atualizado com sucesso! Verifique seu email.')),
          );
        }

        // Redireciona para a tela de confirmação de email ou outra tela
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      _mostrarErro('Erro: $e');
    }
  }

  void _mostrarErro(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
            const SizedBox(height: 60),
            const Text(
              'Oi, seja bem vindo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildSwipeButton(),
            const SizedBox(height: 40),
            _isEmailSelected ? _buildEmailForm() : _buildTelefoneForm(),
            if (!_isEmailSelected && _verificationId != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _smsCodeController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.sms, color: Colors.grey),
                      labelText: 'Código SMS',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verificarCodigoSMS,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF4A3497),
                    ),
                    child: const Text('Verificar Código'),
                  ),
                ],
              ),
            const SizedBox(height: 40),
            if (_showAdditionalFields) _buildContinuarRegistroForm(),
            if (!_showAdditionalFields)
              Column(
                children: [
                  const Text('ou', textAlign: TextAlign.center),
                  const SizedBox(height: 40),
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
            const SizedBox(height: 40),
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
          Align(
            alignment:
                _isEmailSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              alignment: Alignment.center,
              child: Text(
                _isEmailSelected ? 'Telefone' : 'Email',
                style: const TextStyle(
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
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isFormValid
              ? () {
                  _registrarComEmail();
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor:
                _isFormValid ? const Color(0xFF4A3497) : Colors.grey,
          ),
          child: const Text('Registrar-se'),
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
                  _registrarComTelefone();
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor:
                _isFormValid ? const Color(0xFF4A3497) : Colors.grey,
          ),
          child: const Text('Enviar código'),
        ),
      ],
    );
  }

  Widget _buildContinuarRegistroForm() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Continue seu registro',
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
                  _validateForm();
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
          onPressed: _isFormValid
              ? () {
                  _salvarInformacoesAdicionais();
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
          child: const Text('Finalizar registro'),
        ),
      ],
    );
  }
}
