import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: AuctionTestScreen(),
  ));
}

class AuctionTestScreen extends StatelessWidget {
  final String testAuctionId =
      'Q9KKVGJX7ASjr8U9dLgY'; // Substitua pelo ID do leilão que você quer testar

  Future<void> fetchAuction() async {
    try {
      DocumentSnapshot auctionDoc = await FirebaseFirestore.instance
          .collection('auctions')
          .doc(testAuctionId)
          .get();

      if (auctionDoc.exists) {
        print('Leilão encontrado: ${auctionDoc.data()}');
      } else {
        print('Leilão não encontrado para o ID: $testAuctionId');
      }
    } catch (e) {
      print('Erro ao acessar o Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste de Leilão'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchAuction,
          child: Text('Testar Leilão'),
        ),
      ),
    );
  }

  Future<void> testFirestoreAccess(String documentId) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('auctions')
          .doc(documentId)
          .get();

      if (document.exists) {
        print('Leilão encontrado: ${document.data()}');
      } else {
        print('Leilão não encontrado para o ID: $documentId');
      }
    } catch (e) {
      print('Erro ao acessar o Firestore: $e');
    }
  }
}

class MyTestWidget extends StatefulWidget {
  @override
  _MyTestWidgetState createState() => _MyTestWidgetState();
}

class _MyTestWidgetState extends State<MyTestWidget> {
  @override
  void initState() {
    super.initState();

    // Chame a função de teste aqui
    testFirestoreAccess(
        'Q9KKVGJX7ASjr8U9dLgY'); // Substitua pelo ID do documento que deseja testar
  }

  Future<void> testFirestoreAccess(String documentId) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('auctions')
          .doc(documentId)
          .get();

      if (document.exists) {
        print('Leilão encontrado: ${document.data()}');
      } else {
        print('Leilão não encontrado para o ID: $documentId');
      }
    } catch (e) {
      print('Erro ao acessar o Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste Firestore'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Chame a função de teste em resposta a um clique de botão
            testFirestoreAccess('Q9KKVGJX7ASjr8U9dLgY');
          },
          child: Text('Testar Firestore'),
        ),
      ),
    );
  }
}
