import 'package:flutter/material.dart';

import 'onboarding_screen1.dart'; // Import the onboarding screen

class TelaAbertura extends StatelessWidget {
  const TelaAbertura({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the custom blue color
    const Color customBlue = Color(0xFF17153B);

    return Scaffold(
      backgroundColor: customBlue, // Set the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150), // Add space above the logo
            Image.asset('assets/logo.png'), // Place your logo here
            const SizedBox(height: 20),
            const Text(
              'Leilões',
              style: TextStyle(
                fontFamily: 'Merriweather', // Define a fonte Merryweather
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            // Add the button here
            const SizedBox(height: 200), // Increase space above the button
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
                              builder: (context) => const OnboardingScreen1()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Cor do botão
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Remove bordas arredondadas
                        ),
                      ),
                      child: const Text(
                        'Começar',
                        style: TextStyle(
                          fontFamily:
                              'Merriweather', // Define a fonte Merryweather
                          color: Color(0xFF4A3497), // Cor do texto
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
