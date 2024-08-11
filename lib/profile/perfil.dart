import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editar_perfil.dart';
import 'perfil_avancado.dart'; // Importando a página de Perfil Avançado

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  User? user;
  String nome = "";
  String sobrenome = "";
  String celular = "";
  String email = "";
  String fotoUrl = "";

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userData.exists) {
          setState(() {
            nome = userData['nome'] ?? "";
            sobrenome = userData['sobrenome'] ?? "";
            celular = userData['celular'] ?? "";
            email = userData['email'] ?? "";
            fotoUrl = userData['fotoUrl'] ?? 'assets/images/profile.jpg';
          });
        } else {
          // Documento não encontrado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados do usuário não encontrados.')),
          );
        }
      } catch (e) {
        // Erro ao carregar os dados
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar os dados: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: fotoUrl.startsWith('assets')
                      ? AssetImage(fotoUrl)
                      : NetworkImage(fotoUrl) as ImageProvider,
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nome $sobrenome',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(celular),
                    Text(email),
                  ],
                ),
                const Spacer(), // Adiciona espaço flexível entre os widgets
                IconButton(
                  icon: const Icon(Icons.menu), // Ícone de três tracinhos
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PerfilAvancadoScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                ).then((_) => _loadUserData());
              },
              child: const Text('Editar Perfil'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
