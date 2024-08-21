import 'package:clo/leilao/criar_leilao.dart';
import 'package:clo/search/explorar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExplorarScreen()),
      );
    } else if (_selectedIndex == 2) {
      // Lógica para criar novo item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateAuctionScreen()),
      );
    } else if (_selectedIndex == 3) {
      Navigator.pushNamed(context, '/perfil');
    }
  }

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isWideScreen = screenWidth > 600;

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 32.0 : 16.0,
                  vertical: 16.0,
                ),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final title = notification['title'];
                  final details = notification['details'];
                  final timestamp = notification['timestamp'] as Timestamp?;
                  final timeAgo = timestamp != null
                      ? timeAgoSinceDate(timestamp.toDate())
                      : null;

                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      _deleteNotification(notification.id);
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
                    child: buildNotificationCard(
                      title,
                      details,
                      timeAgo,
                      screenWidth,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
                color: Color(0xFF4A3497),
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

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .delete();
      print('Notificação removida com sucesso');
    } catch (e) {
      print('Erro ao remover a notificação: $e');
    }
  }

  String timeAgoSinceDate(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 8) {
      return "${difference.inDays ~/ 7} semana(s) atrás";
    } else if ((difference.inDays / 7).floor() >= 1) {
      return "1 semana atrás";
    } else if (difference.inDays >= 2) {
      return "${difference.inDays} dias atrás";
    } else if (difference.inDays >= 1) {
      return "Ontem";
    } else if (difference.inHours >= 2) {
      return "${difference.inHours} horas atrás";
    } else if (difference.inHours == 1) {
      return "1 hora atrás";
    } else if (difference.inMinutes >= 2) {
      return "${difference.inMinutes} minutos atrás";
    } else if (difference.inMinutes == 1) {
      return "1 minuto atrás";
    } else if (difference.inSeconds >= 3) {
      return "${difference.inSeconds} segundos atrás";
    } else {
      return "Agora";
    }
  }

  Widget buildNotificationCard(
      String title, String details, String? timeAgo, double screenWidth) {
    return Card(
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
    );
  }
}
