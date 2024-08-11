import 'package:clo/leilao/criar_leilao.dart';
import 'package:clo/leilao/leilao.dart';
import 'package:clo/profile/perfil.dart';
import 'package:clo/search/pesquisa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String? _selectedCategory;
  RangeValues _selectedPriceRange = const RangeValues(0, 1000);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
      );
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
                      // Adicione mais categorias conforme necessário
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
                      Navigator.pop(context); // Fecha o BottomSheet
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
    return const Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
              'assets/images/profile.jpg'), // Substitua pelo caminho correto
          radius: 30,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Oi, Alan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Vamos começar os Lances!',
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
    return Column(
      children: [
        _buildSectionHeader('CATEGORIAS', onViewAllPressed: () {
          // Lógica para visualizar todas as categorias
        }),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: StreamBuilder<QuerySnapshot>(
            stream: _getFilteredCategoriesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var categories = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  var category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            category[
                                'imagePath'], // Certifique-se de que o campo está correto
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category['name'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
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
        _buildSectionHeader('EM ALTA'),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: _getFilteredItemsStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var items = snapshot.data!.docs;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
                        child: Image.asset(
                          item[
                              'imagePath'], // Certifique-se de que o campo está correto
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Lance Inicial\nR\$ ${item['price']}',
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

  Stream<QuerySnapshot> _getFilteredCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('categorias')
        .snapshots(); // Filtros de categorias podem ser aplicados aqui, se necessário
  }

  Stream<QuerySnapshot> _getFilteredItemsStream() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('em_alta');

    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    query =
        query.where('price', isGreaterThanOrEqualTo: _selectedPriceRange.start);
    query = query.where('price', isLessThanOrEqualTo: _selectedPriceRange.end);

    return query.snapshots();
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
