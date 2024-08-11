import 'package:flutter/material.dart';

class AuctionDetailScreen extends StatelessWidget {
  final String itemName;
  final String itemImage;
  final double startingPrice;
  final double currentPrice;
  final String timeRemaining;

  const AuctionDetailScreen({
    super.key,
    required this.itemName,
    required this.itemImage,
    required this.startingPrice,
    required this.currentPrice,
    required this.timeRemaining,
  });

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              itemImage,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              itemName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Petersenote',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceInfo('Preço Inicial', startingPrice),
                _buildPriceInfo('Preço Atual', currentPrice),
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
                  timeRemaining,
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
            // Aqui você pode adicionar uma lista de lances
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
            // Lógica para dar lance
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
}
