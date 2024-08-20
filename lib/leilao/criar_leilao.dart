import 'dart:io';

import 'package:clo/leilao/leilao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  _CreateAuctionScreenState createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startingBidController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedDuration;
  String? _sellerName;
  String? _sellerId;
  File? _imageFile;
  bool _isUploading = false;

  // Definindo categorias e subcategorias
  final Map<String, List<String>> categories = {
    'Eletrodoméstico': [],
    'Eletrônicos': [],
    'Móvel': [],
    'Vestiário': [],
    'Calçados': [],
    'Joias': [],
    'Relógios': [],
    'Tecnologia': [
      'Jogos - RPG',
      'Jogos - Computador',
      'Jogos - Console',
      'Periféricos - Monitores',
      'Periféricos - Mouse',
      'Periféricos - Teclado',
      'Periféricos - Headset',
      'Cadeiras',
      'GPUs',
      'Computadores',
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _sellerName = "${userDoc['first_name']} ${userDoc['last_name']}";
          });
        } else {
          print('Documento do usuário não encontrado.');
        }
      } else {
        print('Usuário não autenticado.');
      }
    } catch (e) {
      print('Erro ao carregar o nome do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar Leilão',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _sellerName == null
                ? const Center(child: CircularProgressIndicator())
                : TextFormField(
                    initialValue: _sellerName,
                    decoration: const InputDecoration(
                      labelText: 'Vendedor',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: categories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedSubCategory =
                      null; // Resetar subcategoria ao mudar a categoria
                });
              },
              value: _selectedCategory,
            ),
            const SizedBox(height: 16),
            if (_selectedCategory != null &&
                categories[_selectedCategory]!.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Subcategoria',
                  border: OutlineInputBorder(),
                ),
                items: categories[_selectedCategory]!.map((String subCategory) {
                  return DropdownMenuItem<String>(
                    value: subCategory,
                    child: Text(subCategory),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubCategory = value;
                  });
                },
                value: _selectedSubCategory,
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _startingBidController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Lance Mínimo',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  String newText = newValue.text.replaceAll(',', '.');
                  return newValue.copyWith(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newText.length),
                  );
                }),
              ],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final newValue = value.replaceAll(',', '.');
                  _startingBidController.value =
                      _startingBidController.value.copyWith(
                    text: newValue,
                    selection: TextSelection.collapsed(offset: newValue.length),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Duração do Leilão',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: '5d',
                  child: Text('5 dias'),
                ),
                DropdownMenuItem(
                  value: '3d',
                  child: Text('3 dias'),
                ),
                DropdownMenuItem(
                  value: '1d',
                  child: Text('1 dia'),
                ),
                DropdownMenuItem(
                  value: '8h',
                  child: Text('8 horas'),
                ),
                DropdownMenuItem(
                  value: '5h',
                  child: Text('5 horas'),
                ),
                DropdownMenuItem(
                  value: '1h',
                  child: Text('1 hora'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                color: const Color(0xFF4A3497),
                strokeWidth: 2,
                dashPattern: const [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.center,
                  child: _imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 50,
                              color: Color(0xFF4A3497),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Upload de Imagens',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Color(0xFF4A3497),
                              ),
                            ),
                          ],
                        )
                      : Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isUploading ? null : _createAuction,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF4A3497),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Criar Leilão',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<void> _createAuction() async {
    if (_imageFile == null ||
        _selectedDuration == null ||
        _sellerName == null) {
      print('Erro: Campos obrigatórios não foram preenchidos.');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Erro: Usuário não autenticado');
        return;
      }

      // Obter o ID do vendedor (usuário atual)
      final sellerId = user.uid;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('auction_images')
          .child('${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      print('Caminho de upload: ${storageRef.fullPath}');

      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      final DateTime now = DateTime.now();
      late DateTime endTime;
      switch (_selectedDuration) {
        case '5d':
          endTime = now.add(const Duration(days: 5));
          break;
        case '3d':
          endTime = now.add(const Duration(days: 3));
          break;
        case '1d':
          endTime = now.add(const Duration(days: 1));
          break;
        case '8h':
          endTime = now.add(const Duration(hours: 8));
          break;
        case '5h':
          endTime = now.add(const Duration(hours: 5));
          break;
        case '1h':
          endTime = now.add(const Duration(hours: 1));
          break;
        default:
          endTime = now.add(const Duration(days: 1));
      }

      final auctionDoc =
          FirebaseFirestore.instance.collection('auctions').doc();

      await auctionDoc.set({
        'productName': _productNameController.text,
        'seller': _sellerName,
        'sellerId': sellerId, // Adiciona o ID do vendedor ao documento
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'subCategory': _selectedSubCategory,
        'startingBid': double.parse(_startingBidController.text
            .replaceAll(',', '.')), // Convertendo para formato numérico
        'currentBid': double.parse(_startingBidController.text
            .replaceAll(',', '.')), // Convertendo para formato numérico
        'imagePath': imageUrl,
        'views': 0,
        'createdAt': now,
        'endTime': endTime, // Aqui o 'endTime' é adicionado ao documento
        'timeRemaining': DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime),
        'bids': [], // Inicializa a lista de lances como vazia
        'participants': [], // Inicializa a lista de participantes como vazia
        'winner': null,
      });

      // Imprimir o ID do documento criado
      print('Leilão criado com sucesso. ID: ${auctionDoc.id}');

      // Navegar para a tela de detalhes do leilão usando o ID criado
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuctionDetailScreen(itemId: auctionDoc.id),
        ),
      );
    } catch (e) {
      print('Erro ao criar leilão: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
