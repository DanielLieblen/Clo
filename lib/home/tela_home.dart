import 'package:clo/leilao/leilao.dart';
import 'package:clo/profile/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToCreateAuction(BuildContext context) {
    // Navega para a página de criar leilão
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAuctionScreen()),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    // Navega para a página de editar perfil
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth * 0.4; // Define 40% da largura da tela para cada card

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToEditProfile(context),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/images/profile.jpg'), // Substitua pelo caminho correto da imagem de perfil
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _navigateToEditProfile(context),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Oi, Alan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Vamos começar os lances!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Eletrodomésticos, Joias...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A3497),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune),
                        color: Colors.white,
                        onPressed: () {
                          // Ação para o botão de preferências de pesquisa
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CATEGORIAS',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Ação para o botão "Ver todos"
                  },
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCategoryCard('Tecnologia', 'assets/images/tecnologia.png'),
                buildCategoryCard('Jogos', 'assets/images/game.png'),
                buildCategoryCard('Moda', 'assets/images/vestiario.jpg'),
                buildCategoryCard('Casa', 'assets/images/vaso_planta.jpg'),
                buildCategoryCard('RPG e Tabuleiro', 'assets/images/rpg.jpg'),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EM ALTA',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Ação para o botão "Ver todos"
                  },
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildProductCard(
                  'Mouse Gamer',
                  'Lance Inicial',
                  'R\$ 110,00',
                  'assets/images/mouse.jpg',
                  cardWidth,
                ),
                buildProductCard(
                  'Teclado Mecânico',
                  'Lance Inicial',
                  'R\$ 250,00',
                  'assets/images/teclado.jpg',
                  cardWidth,
                ),
                buildProductCard(
                  'Headset Gamer',
                  'Lance Inicial',
                  'R\$ 200,00',
                  'assets/images/headset.jpg',
                  cardWidth,
                ),
                buildProductCard(
                  'Cadeira Gamer',
                  'Lance Inicial',
                  'R\$ 800,00',
                  'assets/images/cadeira.jpg',
                  cardWidth,
                ),
                buildProductCard(
                  'Monitor 144Hz',
                  'Lance Inicial',
                  'R\$ 1000,00',
                  'assets/images/monitor.jpg',
                  cardWidth,
                ),
                buildProductCard(
                  'PC Gamer',
                  'Lance Inicial',
                  'R\$ 3500,00',
                  'assets/images/pc_gamer.jpg',
                  cardWidth,
                ),
              ],
            ),
          ),
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

  Widget buildCategoryCard(String title, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black54,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(String title, String subtitle, String price,
      String imagePath, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3497),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
