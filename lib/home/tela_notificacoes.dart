import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOTIFICAÇÕES',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isWideScreen = screenWidth > 600;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? 32.0 : 16.0,
              vertical: 16.0,
            ),
            children: [
              buildSectionTitle('Hoje'),
              const SizedBox(height: 8),
              buildNotificationCard('Nome', 'Detalhes da notificação',
                  '3 horas atrás', screenWidth),
              const SizedBox(height: 24),
              buildSectionTitle('Ontem'),
              const SizedBox(height: 8),
              buildNotificationCard(
                  'Nome', 'Detalhes da notificação', null, screenWidth),
              const SizedBox(height: 16),
              buildNotificationCard(
                  'Nome', 'Detalhes da notificação', null, screenWidth),
              const SizedBox(height: 24),
              buildSectionTitle('7 Dias atrás'),
              const SizedBox(height: 8),
              buildNotificationCard(
                  'Nome', 'Detalhes da notificação', null, screenWidth),
              const SizedBox(height: 16),
              buildNotificationCard(
                  'Nome', 'Detalhes da notificação', null, screenWidth),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
                size: 20,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.compass,
                size: 20,
              ),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.plus,
                size: 20,
              ),
              label: 'Criar',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.bell,
                size: 20,
                color:
                    Color(0xFF4A3497), // O sino fica colorido na página atual
              ),
              label: 'Notificações',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                size: 20,
              ),
              label: 'Perfil',
            ),
          ],
          selectedFontSize: 12,
          unselectedFontSize: 10,
          selectedItemColor: const Color(0xFF4A3497),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildNotificationCard(
      String title, String details, String? timeAgo, double screenWidth) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        // Lógica para remover a notificação
        // Aqui você pode implementar a lógica para remover a notificação da lista
      },
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            details,
            style: const TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          trailing: timeAgo != null
              ? Text(
                  timeAgo,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
