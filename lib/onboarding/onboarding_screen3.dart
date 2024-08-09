import 'package:clo/onboarding/bem_vindo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const OnboardingApp3());
}

class OnboardingApp3 extends StatelessWidget {
  const OnboardingApp3({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OnboardingScreen3(),
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra de status e menus de seleção
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    height: 2.0,
                    width: 100.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    height: 2.0,
                    width: 100.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    height: 2.0,
                    width: 100.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagem com cantos arredondados
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/intro3.png',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Adicionando o texto principal
                  const Text(
                    'Leiloe seus produtos com\nrapidez, praticidade e segurança',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                      height:
                          200), // Aumenta o espaço entre o texto e o botão para 100px
                  Expanded(
                    child: Align(
                      alignment: Alignment
                          .topCenter, // Alinha o botão no topo do espaço restante
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0), // Margem de 10px em cada lado
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width -
                              20, // Largura do botão (largura da tela - 20px)
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BemVindoScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A3497),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Próximo',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
