import 'package:clo/home/tela_home.dart';
import 'package:clo/home/tela_notificacoes.dart';
import 'package:clo/leilao/criar_leilao.dart';
import 'package:clo/profile/perfil.dart';
import 'package:clo/search/pesquisa.dart'; // Importe a tela de pesquisa
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  _ExplorarScreenState createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  int _selectedIndex = 1;

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

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Tecnologia', 'imagePath': 'assets/images/tecnologia.png'},
      {'name': 'Jogos', 'imagePath': 'assets/images/game.png'},
      {
        'name': 'Eletrodomésticos',
        'imagePath': 'assets/images/eletrodomesticos.png'
      },
      {'name': 'Móveis', 'imagePath': 'assets/images/moveis.png'},
      {'name': 'Cozinha', 'imagePath': 'assets/images/cozinha.png'},
      {'name': 'Mesa', 'imagePath': 'assets/images/mesa.png'},
      {'name': 'Banho', 'imagePath': 'assets/images/banho.png'},
      {'name': 'Bem-estar', 'imagePath': 'assets/images/bemestar.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implementar lógica para filtros
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          return GestureDetector(
            onTap: () {
              // Navegar para a PesquisaScreen com a categoria selecionada
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PesquisaScreen(
                    selectedCategory: category['name']!,
                    selectedPriceRange: const RangeValues(0, 10000),
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      category['imagePath']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category['name']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
        elevation: 6.0,
        child: const Icon(Icons.add), // Isso dá uma sombra ao botão
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
              icon: FaIcon(
                FontAwesomeIcons.house,
                size: 20,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.compass,
                size: 20,
              ),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: SizedBox
                  .shrink(), // Deixe esse espaço vazio para o botão central
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.bell,
                size: 20,
              ),
              label: 'Notificações',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                size: 20,
              ),
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
}
