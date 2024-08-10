import 'package:clo/home/leilao.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          // Conteúdo da tela principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
                    color: Color(0xFF4A3497), // Cor personalizada do projeto
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
            height: 150, // Altura do carrossel
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCategoryCard('Tecnologia', 'assets/images/tecnologia.png'),
                buildCategoryCard('Jogos', 'assets/images/game.png'),
                buildCategoryCard('Moda', 'assets/images/vestiario.jpg'),
                buildCategoryCard('Casa', 'assets/images/vaso_planta.jpg'),
                buildCategoryCard('RPG e Tabuleiro', 'assets/images/rpg.jpg'),
                // Adicione mais cards conforme necessário
              ],
            ),
          ),
          // Carrossel "Em Alta"
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
            height: 250, // Altura dos cards
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildProductCard(
                  'Mouse Gamer',
                  'Lance Inicial',
                  'R\$ 110,00',
                  'assets/images/mouse.jpg',
                ),
                buildProductCard(
                  'Teclado Mecânico',
                  'Lance Inicial',
                  'R\$ 250,00',
                  'assets/images/teclado.jpg',
                ),
                buildProductCard(
                  'Headset Gamer',
                  'Lance Inicial',
                  'R\$ 200,00',
                  'assets/images/headset.jpg',
                ),
                buildProductCard(
                  'Cadeira Gamer',
                  'Lance Inicial',
                  'R\$ 800,00',
                  'assets/images/cadeira.jpg',
                ),
                buildProductCard(
                  'Monitor 144Hz',
                  'Lance Inicial',
                  'R\$ 1000,00',
                  'assets/images/monitor.jpg',
                ),
                buildProductCard(
                  'PC Gamer',
                  'Lance Inicial',
                  'R\$ 3500,00',
                  'assets/images/pc_gamer.jpg',
                ),
                // Adicione mais cards conforme necessário
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateAuction(context),
        backgroundColor:
            const Color(0xFF4A3497), // Cor personalizada do projeto
        child: const FaIcon(FontAwesomeIcons.plus), // Ícone do FontAwesome
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
                FontAwesomeIcons.home,
                size: 20, // Tamanho reduzido
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.compass,
                size: 20, // Tamanho reduzido
              ),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.bell,
                size: 20, // Tamanho reduzido
              ),
              label: 'Notificações',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                size: 20, // Tamanho reduzido
              ),
              label: 'Perfil',
            ),
          ],
          selectedFontSize: 12, // Tamanho do texto selecionado reduzido
          unselectedFontSize: 10, // Tamanho do texto não selecionado reduzido
          selectedItemColor:
              const Color(0xFF4A3497), // Cor personalizada do projeto
          unselectedItemColor: Colors.grey, // Cor dos ícones não selecionados
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

  Widget buildProductCard(
      String title, String subtitle, String price, String imagePath) {
    return Container(
      width: 150, // Largura dos cards
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
                      color: Color(0xFF4A3497), // Cor personalizada do projeto
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
