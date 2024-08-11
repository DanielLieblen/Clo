import 'package:flutter/material.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),
      body: const Center(
        child: Text('Aqui será exibido o histórico do usuário'),
      ),
    );
  }
}
