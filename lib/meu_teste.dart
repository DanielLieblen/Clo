import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
