import 'package:flutter/material.dart';

class EmAltaScreen extends StatelessWidget {
  const EmAltaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Em Alta', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: const [
          // Produtos em alta
        ],
      ),
    );
  }
}
