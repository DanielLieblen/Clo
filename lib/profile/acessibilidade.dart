import 'package:flutter/material.dart';

class AcessibilidadeScreen extends StatelessWidget {
  const AcessibilidadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acessibilidade'),
      ),
      body: const Center(
        child: Text('Aqui serão exibidas as opções de acessibilidade'),
      ),
    );
  }
}
