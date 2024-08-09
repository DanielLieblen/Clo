import 'package:clo/login/login.dart';
import 'package:clo/registro/email/registro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BemVindoScreen extends StatelessWidget {
  const BemVindoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo e Título
              Column(
                children: [
                  // Substitua 'assets/logo.png' pela imagem do seu logotipo
                  const SizedBox(height: 20),
                  const Text(
                    'Bem vindo à',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                  ),
                  Image.asset(
                    'assets/logo2.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Leilões',
                    style: TextStyle(fontSize: 24, fontFamily: 'Merriweather'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Botão Registrar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegistroScreen()), // Navegação para tela de login
                    ); //lembrar que o telefone eh padrao portanto ela é a tela principal de registro
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3497), // Cor do botão
                    minimumSize:
                        const Size(double.infinity, 50), // Largura cheia
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Borda quadrada
                    ),
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Cor do texto
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Botão Entrar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlinedButton(
                  onPressed: () {
                    print("alguma coisa");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen()), // Navegação para tela de login
                    );
                    // Adicione a navegação para a tela de login aqui
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color(0xFF4A3497)), // Cor da borda
                    minimumSize:
                        const Size(double.infinity, 50), // Largura cheia
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Borda quadrada
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF4A3497), // Cor do texto
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Divider e Ícones de Redes Sociais
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ou'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.facebook,
                          size: 40, color: Colors.blue),
                      const SizedBox(width: 30),
                      Image.asset('assets/google_logo.png',
                          height: 40, width: 40), // Logotipo colorido do Google
                      const SizedBox(width: 30),
                      const FaIcon(FontAwesomeIcons.apple,
                          size: 40, color: Colors.black),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
