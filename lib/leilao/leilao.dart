import 'dart:async';

import 'package:clo/leilao/leilao_descricao.dart'; // Importe a tela AuctionItemDescriptionScreen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuctionDetailScreen extends StatefulWidget {
  final String itemId;

  const AuctionDetailScreen({super.key, required this.itemId});

  @override
  _AuctionDetailScreenState createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  late Stream<DocumentSnapshot> _auctionStream;
  Timer? _auctionTimer;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;

        // Agora, configure o stream após obter o currentUserId
        _auctionStream = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('auctions')
            .doc(widget.itemId)
            .snapshots();

        _startAuctionTimer(); // Inicie o timer após configurar o stream
      });
    }
  }

  void _startAuctionTimer() {
    _auctionTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final auctionDoc =
          FirebaseFirestore.instance.collection('auctions').doc(widget.itemId);
      final auctionData = await auctionDoc.get();

      // Verifique se o documento existe
      if (!auctionData.exists) {
        print('Documento não encontrado para o ID: ${widget.itemId}');
        timer.cancel();
        return;
      }

      // Verifique se o campo 'endTime' existe no documento
      if (auctionData.data()?.containsKey('endTime') ?? false) {
        final DateTime endTime = (auctionData['endTime'] as Timestamp).toDate();

        if (DateTime.now().isAfter(endTime)) {
          await _endAuction(auctionDoc);
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _endAuction(DocumentReference auctionDoc) async {
    final auctionData = await auctionDoc.get();
    final List bids = auctionData['bids'] ?? [];

    if (bids.isNotEmpty) {
      bids.sort((a, b) => b['bidAmount'].compareTo(a['bidAmount']));
      final String winner = bids.first['userId'];
      await auctionDoc.update({'winner': winner, 'isEnded': true});

      _notifySeller(auctionData['sellerId'], winner);
    }
  }

  Future<void> _notifySeller(String sellerId, String winnerId) async {
    final sellerDoc =
        FirebaseFirestore.instance.collection('users').doc(sellerId);
    await sellerDoc.collection('notifications').add({
      'title': 'Leilão encerrado',
      'message': 'Seu leilão terminou. O vencedor é o usuário $winnerId.',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _auctionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _auctionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar leilão',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            print('Leilão não encontrado com ID: ${widget.itemId}');
            return const Center(
              child: Text(
                'Erro: Leilão não encontrado',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // Verificação se snapshot.data.data() é null
          final auctionData = snapshot.data!.data() as Map<String, dynamic>?;
          print('Dados do leilão: $auctionData');
          if (auctionData == null) {
            return const Center(
              child: Text(
                'Erro: Leilão não encontrado',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final bool isEnded = auctionData.containsKey('isEnded')
              ? auctionData['isEnded']
              : false;
          final String description = auctionData.containsKey('description')
              ? auctionData['description']
              : '';
          final bool isSeller = currentUserId == auctionData['sellerId'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  auctionData['imagePath'],
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuctionItemDescriptionScreen(
                          itemName: auctionData['productName'],
                          itemDescription: description,
                          itemImage: auctionData['imagePath'],
                          sellerName: auctionData['seller'],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    auctionData['productName'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  auctionData['seller'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriceInfo(
                        'Preço Inicial', auctionData['startingBid']),
                    _buildPriceInfo('Preço Atual', auctionData['currentBid']),
                  ],
                ),
                const SizedBox(height: 20),
                if (!isEnded)
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/default_profile.jpg'),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'em live',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        _formatTimeRemaining(
                            auctionData['endTime'] as Timestamp),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                if (isEnded)
                  const Text(
                    'Leilão Encerrado',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Lances',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                if (!isEnded && !isSeller) _buildBidSection(auctionData),
                if (isSeller)
                  const Text(
                    'Você não pode participar do seu próprio leilão.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimeRemaining(Timestamp endTime) {
    final Duration remaining = endTime.toDate().difference(DateTime.now());
    final String hours = remaining.inHours.toString().padLeft(2, '0');
    final String minutes =
        (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds =
        (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Widget _buildPriceInfo(String title, double price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'R\$ $price',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildBidSection(Map<String, dynamic> auctionData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildBidButton('R\$1.000', auctionData['currentBid'] + 1000),
            _buildBidButton('R\$2.000', auctionData['currentBid'] + 2000),
            _buildBidButton('Preço Customizado', null),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _showBidConfirmationDialog(
                context, auctionData['currentBid'] + 500);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A3497),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Dar Lance'),
        ),
      ],
    );
  }

  Widget _buildBidButton(String label, double? bidAmount) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (bidAmount != null) {
            _showBidConfirmationDialog(context, bidAmount);
          } else {
            // Lógica para lance customizado
          }
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  void _showBidConfirmationDialog(BuildContext context, double bidAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lance Feito'),
          content:
              Text('Você deu um lance de R\$ $bidAmount. Confirma este lance?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _placeBid(bidAmount);
                Navigator.of(context).pop();
              },
              child: const Text('Sim, Confirmar Lance'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeBid(double bidAmount) async {
    final auctionDoc =
        FirebaseFirestore.instance.collection('auctions').doc(widget.itemId);

    await auctionDoc.update({
      'currentBid': bidAmount,
      'bids': FieldValue.arrayUnion([
        {
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'bidAmount': bidAmount,
          'timestamp': FieldValue.serverTimestamp(),
        }
      ]),
    });
  }
}
