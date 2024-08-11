import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PesquisaScreen extends StatefulWidget {
  final String? selectedCategory;
  final RangeValues selectedPriceRange;

  const PesquisaScreen({
    super.key,
    this.selectedCategory,
    required this.selectedPriceRange,
  });

  @override
  _PesquisaScreenState createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Lógica para navegação com base no índice selecionado
    if (_selectedIndex == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (_selectedIndex == 1) {
      // Implementar lógica para explorar
    } else if (_selectedIndex == 2) {
      // Implementar lógica para notificações
    } else if (_selectedIndex == 3) {
      Navigator.pushReplacementNamed(context, '/perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descubra novos itens!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            _buildFilterButtons(),
            const SizedBox(height: 20),
            Expanded(child: _buildItemsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para criar leilão
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

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterButton('Todos', onTap: () {
            // Redirecionar para todos os itens
          }),
          _buildFilterButton('Recomendações', onTap: () {
            // Redirecionar para recomendações
          }),
          _buildFilterButton('Popular', onTap: () {
            // Redirecionar para itens populares
          }),
          _buildFilterButton('Grátis', onTap: () {
            // Redirecionar para itens grátis
          }),
          _buildFilterButton('Lançamentos', onTap: () {
            // Redirecionar para lançamentos
          }),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A3497),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildItemsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getFilteredItemsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var items = snapshot.data!.docs;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return _buildItemCard(item);
          },
        );
      },
    );
  }

  Widget _buildItemCard(DocumentSnapshot item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                item['imagePath'],
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              if (item['isNew'] == true)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.red,
                    child: const Text(
                      'Novo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${item['price']}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Redirecionar para a página de leilão correspondente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeilaoScreen(leilaoId: item.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3497),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Dar Lance'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredItemsStream() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('em_alta');

    if (widget.selectedCategory != null) {
      query = query.where('category', isEqualTo: widget.selectedCategory);
    }

    query = query.where('price',
        isGreaterThanOrEqualTo: widget.selectedPriceRange.start);
    query = query.where('price',
        isLessThanOrEqualTo: widget.selectedPriceRange.end);

    return query.snapshots();
  }
}

class LeilaoScreen extends StatelessWidget {
  final String leilaoId;

  const LeilaoScreen({super.key, required this.leilaoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leilão'),
      ),
      body: Center(
        child: Text('Detalhes do leilão: $leilaoId'),
      ),
    );
  }
}
