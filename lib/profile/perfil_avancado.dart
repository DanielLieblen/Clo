import 'package:clo/onboarding/tela_abertura.dart';
import 'package:clo/profile/acessibilidade.dart';
import 'package:clo/profile/configuracoes.dart';
import 'package:clo/profile/historico.dart';
import 'package:clo/profile/informacoes_pessoais.dart';
import 'package:clo/profile/metodos_pagamento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilAvancadoScreen extends StatelessWidget {
  const PerfilAvancadoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Avançado'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            _buildProfileOption(
              context,
              icon: Icons.person,
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
              icon: Icons.settings,
              title: 'Configurações',
              page: const SettingsScreen(),
            ),
            _buildProfileOption(
              context,
              icon: Icons.payment,
              title: 'Métodos De Pagamento',
              page: const MetodosPagamentoScreen(),
            ),
            _buildProfileOption(
              context,
              icon: Icons.accessibility,
              title: 'Acessibilidade',
              page: const AcessibilidadeScreen(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaAbertura()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Deslogar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
