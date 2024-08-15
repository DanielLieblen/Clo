import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  String? _selectedDuration;
  String? _sellerName; // Nome do vendedor (usuário)
  File? _imageFile; // Para armazenar a imagem selecionada
  bool _isUploading = false; // Para controlar o estado de upload

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
            _sellerName =
                "${userDoc['first_name']} ${userDoc['last_name']}"; // Assumindo que os campos 'nome' e 'sobrenome' existem
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
                    readOnly: true, // Campo somente leitura, não editável
                  ),
            const SizedBox(height: 16),
            TextFormField(
              controller:
                  _productNameController, // Campo para o nome do produto
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
              items: const [
                DropdownMenuItem(
                  value: 'Eletrodomestico',
                  child: Text('Eletrodoméstico'),
                ),
                DropdownMenuItem(
                  value: 'Eletronicos',
                  child: Text('Eletrônicos'),
                ),
                DropdownMenuItem(
                  value: 'Movel',
                  child: Text('Móvel'),
                ),
                DropdownMenuItem(
                  value: 'Vestimenta',
                  child: Text('Vestimenta'),
                ),
                DropdownMenuItem(
                  value: 'Calçados',
                  child: Text('Calçados'),
                ),
                DropdownMenuItem(
                  value: 'Joias',
                  child: Text('Joias'),
                ),
                DropdownMenuItem(
                  value: 'Relógios',
                  child: Text('Relógios'),
                ),
                DropdownMenuItem(
                  value: 'Tecnologia',
                  child: Text('Tecnologia'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Produto',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _startingBidController,
              decoration: const InputDecoration(
                labelText: 'Lance Mínimo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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

      // Upload da imagem para o Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('auction_images')
          .child('${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      print('Caminho de upload: ${storageRef.fullPath}');

      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Calculando o tempo final do leilão
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

      // Criar o documento do leilão no Firestore
      final auctionDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('auctions')
          .doc();

      await auctionDoc.set({
        'productName': _productNameController.text, // Nome do produto
        'seller': _sellerName,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'startingBid': double.parse(_startingBidController.text),
        'currentBid': double.parse(
            _startingBidController.text), // Inicialmente igual ao lance mínimo
        'imagePath': imageUrl, // Caminho da imagem no Firebase Storage
        'views': 0,
        'createdAt': now,
        'endTime': endTime,
        'timeRemaining': DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime),
        'bids': [], // Lista de lances
        'winner': null, // Inicialmente, não há vencedor
      });

      print('Leilão criado com sucesso');
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao criar leilão: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Função para verificar se o leilão terminou e determinar o vencedor
  Future<void> checkAuctionEnd() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Erro: Usuário não autenticado');
      return;
    }

    final auctions = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('auctions')
        .where('endTime', isLessThanOrEqualTo: DateTime.now())
        .where('winner', isEqualTo: null)
        .get();

    for (var auction in auctions.docs) {
      final bids = auction['bids'] as List<dynamic>;
      if (bids.isNotEmpty) {
        bids.sort((a, b) => b['amount'].compareTo(a['amount']));
        final winner = bids.first['bidder'];
        await auction.reference.update({'winner': winner});
        print('Vencedor do leilão ${auction.id}: $winner');
      } else {
        print('Leilão ${auction.id} terminou sem lances.');
      }
    }
  }
}
