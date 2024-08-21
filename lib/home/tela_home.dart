import 'dart:io';

import 'package:clo/home/tela_notificacoes.dart';
import 'package:clo/leilao/criar_leilao.dart';
import 'package:clo/leilao/leilao.dart';
import 'package:clo/profile/perfil.dart';
import 'package:clo/search/explorar.dart';
import 'package:clo/search/pesquisa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _userName;
  String? _profileImageUrl;
  File? _imageFile;
  String? _selectedCategory;
  RangeValues _selectedPriceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['first_name'] ?? 'Usuário';
          _profileImageUrl = userDoc['profileImageUrl'];
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // Não faça nada se o índice já estiver selecionado
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _uploadProfileImage();
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _imageFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': downloadUrl});

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      print('Upload bem-sucedido: $downloadUrl');
      _loadUserProfile();
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
    }
  }

  void _navigateToCreateAuction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAuctionScreen()),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtrar por:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Categoria'),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Todas'),
                      ),
                      DropdownMenuItem(
                        value: 'Tecnologia',
                        child: Text('Tecnologia'),
                      ),
                      DropdownMenuItem(
                        value: 'Eletrodomésticos',
                        child: Text('Eletrodomésticos'),
                      ),
                      DropdownMenuItem(
                        value: 'Moveis',
                        child: Text('Moveis'),
                      ),
                      DropdownMenuItem(
                        value: 'Bem-estar',
                        child: Text('Bem-estar'),
                      ),
                      DropdownMenuItem(
                        value: 'Cozinha',
                        child: Text('Cozinha'),
                      ),
                      DropdownMenuItem(
                        value: 'Mesa',
                        child: Text('Mesa'),
                      ),
                      DropdownMenuItem(
                        value: 'Banho',
                        child: Text('Banho'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 20),
                  const Text('Faixa de Preço (R\$)'),
                  RangeSlider(
                    values: _selectedPriceRange,
                    min: 0,
                    max: 1000,
                    divisions: 10,
                    labels: RangeLabels(
                      _selectedPriceRange.start.round().toString(),
                      _selectedPriceRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _selectedPriceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PesquisaScreen(
                            selectedCategory: _selectedCategory,
                            selectedPriceRange: _selectedPriceRange,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3497),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Aplicar Filtros'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToAllCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllCategoriesScreen()),
    );
  }

  void _navigateToCategoryAuctions(BuildContext context, String category) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PesquisaScreen(
            selectedCategory: category,
            selectedPriceRange: const RangeValues(0, 10000),
          ),
        ));
  }

  void _onSearchSubmitted(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PesquisaScreen(
          searchQuery: query,
          selectedPriceRange: _selectedPriceRange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUserInfo(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCategoriesSection(),
          const SizedBox(height: 20),
          _buildPopularSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateAuction(context),
        backgroundColor: const Color(0xFF4A3497),
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house, size: 20),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.compass, size: 20),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell, size: 20),
              label: 'Notificações',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user, size: 20),
              label: 'Perfil',
            ),
          ],
          selectedFontSize: 12,
          unselectedFontSize: 10,
          selectedItemColor: const Color(0xFF4A3497),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            backgroundImage: _profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : const AssetImage('assets/images/default_profile.jpg')
                    as ImageProvider,
            radius: 30,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_userName ?? 'Usuário',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Vamos começar os Lances!',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Eletrodomésticos, Joias...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSubmitted: _onSearchSubmitted,
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.sliders),
          onPressed: () {
            _showFiltersBottomSheet(context);
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Tecnologia', 'imagePath': 'assets/images/tecnologia.png'},
      {'name': 'Jogos', 'imagePath': 'assets/images/game.png'},
      {'name': 'Monitores', 'imagePath': 'assets/images/monitor.jpg'},
      {'name': 'Headsets', 'imagePath': 'assets/images/headset.jpg'},
      {'name': 'Cadeiras', 'imagePath': 'assets/images/cadeira.jpg'},
      {'name': 'GPU', 'imagePath': 'assets/images/gpu.jpg'},
      {'name': 'PC Gamer', 'imagePath': 'assets/images/pc_gamer.jpg'},
      {'name': 'RPG', 'imagePath': 'assets/images/rpg.jpg'},
      {'name': 'Decoração', 'imagePath': 'assets/images/vaso_planta.jpg'},
      {'name': 'Vestiário', 'imagePath': 'assets/images/vestiario.jpg'},
    ];

    return Column(
      children: [
        _buildSectionHeader('CATEGORIAS', onViewAllPressed: () {
          _navigateToAllCategories(context);
        }),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    _navigateToCategoryAuctions(context, category['name']!);
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          category['imagePath']!,
                          fit: BoxFit.cover,
                          height: 70,
                          width: 120,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category['name']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Column(
      children: [
        _buildSectionHeader('EM ALTA', onViewAllPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AllAuctionsScreen(),
            ),
          );
        }),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: _getFilteredItemsStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var items = snapshot.data!.docs;
            if (items.isEmpty) {
              return const Center(
                  child: Text('Nenhum leilão em alta no momento.'));
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AuctionDetailScreen(itemId: item.id),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['imagePath'],
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width > 600
                              ? 150
                              : 100,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['productName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Lance Inicial\nR\$ ${item['startingBid']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (onViewAllPressed != null)
          TextButton(
            onPressed: onViewAllPressed,
            child: const Text('Ver todos'),
          ),
      ],
    );
  }

  Stream<QuerySnapshot> _getFilteredItemsStream() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collectionGroup('auctions');

    query = query
        .where('startingBid', isGreaterThanOrEqualTo: 0)
        .orderBy('createdAt', descending: true);

    return query.snapshots();
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Tecnologia', 'imagePath': 'assets/images/tecnologia.png'},
      {'name': 'Jogos', 'imagePath': 'assets/images/game.png'},
      {'name': 'Monitores', 'imagePath': 'assets/images/monitor.jpg'},
      {'name': 'Headsets', 'imagePath': 'assets/images/headset.jpg'},
      {'name': 'Cadeiras', 'imagePath': 'assets/images/cadeira.jpg'},
      {'name': 'GPU', 'imagePath': 'assets/images/gpu.jpg'},
      {'name': 'PC Gamer', 'imagePath': 'assets/images/pc_gamer.jpg'},
      {'name': 'RPG', 'imagePath': 'assets/images/rpg.jpg'},
      {'name': 'Decoração', 'imagePath': 'assets/images/vaso_planta.jpg'},
      {'name': 'Vestiário', 'imagePath': 'assets/images/vestiario.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as Categorias'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryAuctionsScreen(
                    category: category['name'] ?? 'Nome Desconhecido',
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    category['imagePath']!,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width > 600 ? 150 : 100,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  category['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CategoryAuctionsScreen extends StatelessWidget {
  final String category;

  const CategoryAuctionsScreen({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leilões em $category'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('auctions')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var items = snapshot.data!.docs;
          if (items.isEmpty) {
            return const Center(child: Text('Nenhum leilão encontrado.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AuctionDetailScreen(itemId: item.id),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['imagePath'],
                        fit: BoxFit.cover,
                        height:
                            MediaQuery.of(context).size.width > 600 ? 150 : 100,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['productName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lance Inicial\nR\$ ${item['startingBid']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AllAuctionsScreen extends StatelessWidget {
  const AllAuctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Leilões'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('auctions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var items = snapshot.data!.docs;
          if (items.isEmpty) {
            return const Center(child: Text('Nenhum leilão em andamento.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              var imageUrl =
                  item['imagePath'] ?? 'assets/images/default_image.jpg';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AuctionDetailScreen(itemId: item.id),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.width > 600
                                  ? 150
                                  : 100,
                              width: double.infinity,
                            )
                          : Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.width > 600
                                  ? 150
                                  : 100,
                              width: double.infinity,
                            ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['productName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lance Inicial\nR\$ ${item['startingBid']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
