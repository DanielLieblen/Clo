import 'package:clo/leilao/leilao_descricao.dart';
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
  DocumentSnapshot? auctionData;

  @override
  void initState() {
    super.initState();
    _loadAuctionData();
  }

  Future<void> _loadAuctionData() async {
    final auctionDoc =
        FirebaseFirestore.instance.collection('auctions').doc(widget.itemId);

    final snapshot = await auctionDoc.get();
    setState(() {
      auctionData = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (auctionData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              auctionData!['imagePath'],
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
                      itemName: auctionData!['description'],
                      itemDescription: auctionData!['description'],
                      itemImage: auctionData!['imagePath'],
                      sellerName: auctionData!['seller'],
                    ),
                  ),
                );
              },
              child: Text(
                auctionData!['description'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              auctionData!['seller'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceInfo('Preço Inicial', auctionData!['startingBid']),
                _buildPriceInfo('Preço Atual', auctionData!['currentBid']),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(width: 10),
                const Text(
                  'em live',
                  style: TextStyle(color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  auctionData!['timeRemaining'],
                  style: const TextStyle(color: Colors.red),
                ),
              ],
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
            _buildBidSection(),
          ],
        ),
      ),
    );
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBidSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildBidButton('R\$1.000'),
            _buildBidButton('R\$2.000'),
            _buildBidButton('Preço Customizado'),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _showBidConfirmationDialog(
                context, auctionData!['currentPrice'] + 500);
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

  Widget _buildBidButton(String label) {
    return Expanded(
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
      'currentPrice': bidAmount,
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
