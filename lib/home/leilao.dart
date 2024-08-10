import 'package:flutter/material.dart';

class CreateAuctionScreen extends StatelessWidget {
  const CreateAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Leilão'),
        backgroundColor: const Color(0xFF4A3497), // Cor personalizada
      ),
      body: const Center(
        child: Text('Tela para criar leilão'),
      ),
    );
  }
}
