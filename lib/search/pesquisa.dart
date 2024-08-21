import 'package:clo/home/tela_notificacoes.dart';
import 'package:clo/leilao/leilao.dart';
import 'package:clo/search/explorar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PesquisaScreen extends StatefulWidget {
  String? selectedCategory;
  String? searchQuery;
  final RangeValues selectedPriceRange;

  PesquisaScreen({
    super.key,
    this.selectedCategory,
    this.searchQuery,
    required this.selectedPriceRange,
  });

  @override
  _PesquisaScreenState createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  int _selectedIndex = 0;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (_selectedIndex == 1) {
      // lógica para explorar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExplorarScreen()),
      );
    } else if (_selectedIndex == 2) {
      // lógica para notificações
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotificationsScreen()),
      );
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

  final FocusNode _searchFocusNode = FocusNode();

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Buscar',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            setState(() {
              widget.searchQuery = '';
              widget.selectedCategory = null;
            });
          },
        ),
      ),
      onChanged: (text) {
        setState(() {
          widget.searchQuery = text;
          widget.selectedCategory = null;
        });
      },
      onSubmitted: (text) {
        setState(() {
          widget.searchQuery = text;
          widget.selectedCategory = null;
        });
        _searchFocusNode.unfocus();
      },
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterButton('Todos', onTap: () {
            setState(() {
              widget.selectedCategory = null;
            });
          }),
          _buildFilterButton('Recomendações', onTap: () {
            setState(() {
              widget.selectedCategory = 'Recomendações';
            });
          }),
          _buildFilterButton('Popular', onTap: () {
            setState(() {
              widget.selectedCategory = 'Popular';
            });
          }),
          _buildFilterButton('Grátis', onTap: () {
            setState(() {
              widget.selectedCategory = 'Grátis';
            });
          }),
          _buildFilterButton('Lançamentos', onTap: () {
            setState(() {
              widget.selectedCategory = 'Lançamentos';
            });
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
        if (items.isEmpty) {
          return const Center(child: Text('Nenhum item encontrado.'));
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
            return _buildItemCard(item);
          },
        );
      },
    );
  }

  // Função para obter a URL da imagem no Firebase Storage
  Future<String> _getImageUrl(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  }

  Widget _buildItemCard(DocumentSnapshot item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuctionDetailScreen(itemId: item.id),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item[
                  'imagePath'], // Certifique-se de que este caminho esteja correto
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width > 600 ? 150 : 100,
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
  }

  Stream<QuerySnapshot> _getFilteredItemsStream() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('auctions');

    // Filtro de categoria
    if (widget.selectedCategory != null &&
        widget.selectedCategory!.isNotEmpty) {
      query = query.where('category', isEqualTo: widget.selectedCategory);
    }

    // Filtro pelo nome do produto usando a string de busca (search query)
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      query = query
          .orderBy('productName')
          .startAt([widget.searchQuery!.toLowerCase()]).endAt(
              ['${widget.searchQuery!.toLowerCase()}\uf8ff']);
    }

    // Filtro de faixa de preço
    if (widget.selectedPriceRange.start > 0 ||
        widget.selectedPriceRange.end < double.infinity) {
      query = query
          .where('startingBid',
              isGreaterThanOrEqualTo: widget.selectedPriceRange.start)
          .where('startingBid',
              isLessThanOrEqualTo: widget.selectedPriceRange.end);
    }

    return query.snapshots();
  }
}
