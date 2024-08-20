import 'package:clo/search/pesquisa.dart'; // Importe a tela de pesquisa
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CATEGORIAS',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isWideScreen = screenWidth > 600;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? 32.0 : 16.0,
              vertical: 16.0,
            ),
            children: [
              buildCategoryCard(
                'Tecnologia',
                'assets/images/tecnologia.png',
                screenWidth,
                context,
                'Tecnologia', // Categoria a ser filtrada
              ),
              const SizedBox(height: 16),
              buildCategoryCard(
                'Jogos e Consoles',
                'assets/images/game.png',
                screenWidth,
                context,
                'Jogos e Consoles', // Categoria a ser filtrada
              ),
              const SizedBox(height: 16),
              buildCategoryCard(
                'RPG e Tabuleiro',
                'assets/images/rpg.png',
                screenWidth,
                context,
                'RPG e Tabuleiro', // Categoria a ser filtrada
              ),
              const SizedBox(height: 16),
              buildCategoryCard(
                'Vestiário',
                'assets/images/vestiario.jpg',
                screenWidth,
                context,
                'Vestiário', // Categoria a ser filtrada
              ),
              // Adicione mais categorias conforme necessário
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação para o botão flutuante
        },
        backgroundColor: const Color(0xFF4A3497),
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
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

  Widget buildCategoryCard(String title, String imagePath, double screenWidth,
      BuildContext context, String category) {
    final cardHeight = screenWidth > 600 ? 200.0 : 180.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PesquisaScreen(
              selectedCategory: category,
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
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: cardHeight,
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.black54,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: screenWidth > 600 ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
