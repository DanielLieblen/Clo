import 'package:clo/home/tela_home.dart';
import 'package:clo/leilao/criar_leilao.dart'; // Certifique-se de importar corretamente a tela de criação de leilão.
import 'package:clo/search/pesquisa.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExplorarScreen extends StatefulWidget {
  @override
  _ExplorarScreenState createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  String? _selectedCategory;
  RangeValues _selectedPriceRange = const RangeValues(0, 10000);

  void _navigateToCategoryAuctions(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PesquisaScreen(
          selectedCategory: category,
          selectedPriceRange: _selectedPriceRange,
        ),
      ),
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
                      DropdownMenuItem(value: null, child: Text('Todas')),
                      DropdownMenuItem(
                          value: 'Tecnologia', child: Text('Tecnologia')),
                      DropdownMenuItem(
                          value: 'Eletrodomésticos',
                          child: Text('Eletrodomésticos')),
                      DropdownMenuItem(value: 'Móveis', child: Text('Móveis')),
                      DropdownMenuItem(
                          value: 'Bem-estar', child: Text('Bem-estar')),
                      DropdownMenuItem(
                          value: 'Cozinha', child: Text('Cozinha')),
                      DropdownMenuItem(value: 'Mesa', child: Text('Mesa')),
                      DropdownMenuItem(value: 'Banho', child: Text('Banho')),
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
                    max: 10000,
                    divisions: 100,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersBottomSheet(context),
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
            onTap: () =>
                _navigateToCategoryAuctions(context, category['name']!),
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
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
