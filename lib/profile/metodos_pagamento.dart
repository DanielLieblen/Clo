import 'package:flutter/material.dart';

class MetodosPagamentoScreen extends StatelessWidget {
  const MetodosPagamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos De Pagamento'),
      ),
      body: const Center(
        child: Text('Aqui serão exibidos os métodos de pagamento'),
      ),
    );
  }
}
