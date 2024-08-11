import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  _CreateAuctionScreenState createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  final TextEditingController _sellerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startingBidController = TextEditingController();
  final TextEditingController _maxBidController = TextEditingController();
  String? _selectedCategory;
  File? _imageFile; // Para armazenar a imagem selecionada
  bool _isUploading = false; // Para controlar o estado de upload

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
            TextFormField(
              controller: _sellerController,
              decoration: const InputDecoration(
                labelText: 'Vendedor',
                border: OutlineInputBorder(),
              ),
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
              controller: _startingBidController,
              decoration: const InputDecoration(
                labelText: 'Lance Mínimo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxBidController,
              decoration: const InputDecoration(
                labelText: 'Lance Máximo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
    }
  }

  Future<void> _createAuction() async {
    if (_imageFile == null) {
      // Trate o caso onde a imagem não foi selecionada
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Trate o caso onde o usuário não está autenticado
        return;
      }

      // Upload da imagem para o Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('auction_images')
          .child('${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Criar o documento do leilão no Firestore
      final auctionDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('auctions')
          .doc();

      await auctionDoc.set({
        'seller': _sellerController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'startingBid': double.parse(_startingBidController.text),
        'currentBid': double.parse(
            _startingBidController.text), // Inicialmente igual ao lance mínimo
        'imagePath': imageUrl, // Caminho da imagem no Firebase Storage
        'views': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'timeRemaining': '01:23:45', // Atualize conforme necessário
        'bids': [], // Lista de lances
      });

      Navigator.pop(context);
    } catch (e) {
      // Trate erros aqui
      print('Erro ao criar leilão: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
