import 'package:clo/home/tela_home.dart';
import 'package:clo/home/tela_notificacoes.dart';
import 'package:clo/leilao/criar_leilao.dart';
import 'package:clo/search/explorar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editar_perfil.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _selectedIndex = 3;
  User? user;
  String nome = "";
  String sobrenome = "";
  String celular = "";
  String email = "";
  String fotoUrl = "";
  int pecas = 0;
  int vendidos = 0;
  double precoMedio = 0.0;

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
            nome = userData['first_name'] ?? "";
            sobrenome = userData['last_name'] ?? "";
            celular = userData['celular'] ?? "";
            email = userData['email'] ?? "";
            fotoUrl =
                (userData['fotoUrl'] != null && userData['fotoUrl'].isNotEmpty)
                    ? userData['fotoUrl']
                    : 'assets/images/default_profile.jpg';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dados do usuário não encontrados.')),
          );
        }

        QuerySnapshot pecasSnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where('ownerId', isEqualTo: user!.uid)
            .get();

        int pecasCount = 0;
        int vendidosCount = 0;
        double totalPrecoVendido = 0.0;

        for (var item in pecasSnapshot.docs) {
          bool vendido = item['winner'] != null && item['winner'].isNotEmpty;
          double preco = item['preco'] ?? 0.0;

          if (vendido) {
            vendidosCount++;
            totalPrecoVendido += preco;
          } else {
            pecasCount++;
          }
        }

        double precoMedioCalculado =
            vendidosCount > 0 ? totalPrecoVendido / vendidosCount : 0.0;

        setState(() {
          pecas = pecasCount;
          vendidos = vendidosCount;
          precoMedio = precoMedioCalculado;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar os dados: $e')),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (_selectedIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ExplorarScreen()),
      );
    } else if (_selectedIndex == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
      );
    } else if (_selectedIndex == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16.0),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$nome $sobrenome',
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$pecas',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Peças'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$vendidos',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Vendidos'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'R\$ ${precoMedio.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Preço Médio'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          ).then((_) => _loadUserData());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A3497),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Editar Perfil'),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Ação para o botão de menu (Perfil Avançado)
                  },
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 16.0),
            const Text(
              'Em busca de várias bugigangas para completar meu Setup.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Color(0xFF4A3497),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF4A3497),
                    tabs: [
                      Tab(text: 'Produtos'),
                      Tab(text: 'Favoritos'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: width > 600 ? 4 : 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(child: Text('Produto')),
                            );
                          },
                        ),
                        GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: width > 600 ? 4 : 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(child: Text('Favorito')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateAuctionScreen()),
          );
        },
        backgroundColor: const Color(0xFF4A3497),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
