import 'package:flutter/material.dart';

class NotificacoesScreen extends StatelessWidget {
  final List<String> notifications = [
    'Notificação 1',
    'Notificação 2',
    'Notificação 3'
  ];
  NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(notifications[index]),
            onDismissed: (direction) {
              // Lógica para apagar a notificação
            },
            background: Container(color: Colors.red),
            child: Card(
              child: ListTile(
                title: Text(notifications[index]),
                subtitle: Text('Descrição da notificação'),
              ),
            ),
          );
        },
      ),
    );
  }
}
