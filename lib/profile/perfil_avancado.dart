import 'package:clo/onboarding/tela_abertura.dart';
import 'package:clo/profile/acessibilidade.dart';
import 'package:clo/profile/configuracoes.dart';
import 'package:clo/profile/historico.dart';
import 'package:clo/profile/informacoes_pessoais.dart';
import 'package:clo/profile/metodos_pagamento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilAvancadoScreen extends StatelessWidget {
  const PerfilAvancadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil Avançado',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            ),
            const SizedBox(height: 10),
            Text(
              user?.displayName ?? 'Usuário',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileOption(
              context,
              icon: Icons.person_outline,
              title: 'Informação Pessoal',
              page: const InformacoesPessoaisScreen(),
            ),
            _buildProfileOption(
              context,
              icon: Icons.history,
              title: 'Histórico',
              page: const HistoricoScreen(),
            ),
            _buildProfileOption(
              context,
              icon: Icons.settings_outlined,
              title: 'Configurações',
              page: const SettingsScreen(),
            ),
            _buildProfileOption(
              context,
              icon: Icons.payment_outlined,
              title: 'Métodos De Pagamento',
              page: const MetodosPagamentoScreen(),
            ),
            _buildProfileOption(
              context,
              icon: Icons.accessibility_new_outlined,
              title: 'Acessibilidade',
              page: const AcessibilidadeScreen(),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaAbertura()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Deslogar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF4A3497),
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF4A3497)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A3497)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
