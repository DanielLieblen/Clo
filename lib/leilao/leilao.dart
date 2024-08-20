import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AuctionDetailScreen extends StatefulWidget {
  final String itemId;

  const AuctionDetailScreen({super.key, required this.itemId});

  @override
  _AuctionDetailScreenState createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  late Stream<DocumentSnapshot> _auctionStream;
  Timer? _auctionTimer;
  Timer? _countdownTimer;
  Timer? _clockTimer;
  String? currentUserId;
  String? currentUserName;
  String? _sellerId;
  bool? _isSeller;

  final TextEditingController _customBidController = TextEditingController();
  DateTime? endTime;
  List<String> liveParticipants = []; // Lista de participantes ao vivo

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('Item ID: ${widget.itemId}');
    }
    _getCurrentUserId();
    _initializeAuctionStream();
    _initializeNotifications();
    _startClockTimer(); // Inicia o timer do relógio
    _checkIfSeller(); // Verifica se o usuário é o vendedor
    // Verifica se o usuário é o vendedor
    _checkIfSeller().then((isSeller) {
      setState(() {
        _isSeller = isSeller;
      });
    });
  }

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _auctionTimer?.cancel();
    _countdownTimer?.cancel();
    _clockTimer?.cancel();
    _customBidController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'auction_channel',
      'Leilão',
      channelDescription: 'Notificações de leilão',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Leilão',
      message,
      platformChannelSpecifics,
      payload: 'Leilão em andamento',
    );
  }

  Future<void> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });

      await _getUserName(currentUserId!); // Carrega o nome do usuário
      print('Current User ID: $currentUserId');
    }
  }

  Future<void> _getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          currentUserName = userDoc.data()!['first_name'] ?? 'Desconhecido';
        });
      } else {
        setState(() {
          currentUserName = 'Desconhecido';
        });
      }
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      setState(() {
        currentUserName = 'Desconhecido';
      });
    }
  }

  void _initializeAuctionStream() {
    _auctionStream = FirebaseFirestore.instance
        .collection('auctions')
        .doc(widget.itemId)
        .snapshots();

    _auctionStream.listen((snapshot) {
      final auctionData = snapshot.data() as Map<String, dynamic>;
      if (auctionData.containsKey('endTime')) {
        setState(() {
          endTime = (auctionData['endTime'] as Timestamp).toDate();
        });
      }
      if (auctionData.containsKey('liveParticipants')) {
        setState(() {
          liveParticipants = List<String>.from(auctionData['liveParticipants']);
        });
      }
      final sellerId = auctionData['sellerId'];
      print('Seller ID: $sellerId');
    });
    _startAuctionTimer();
  }

  void _startAuctionTimer() {
    _auctionTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (endTime != null && DateTime.now().isAfter(endTime!)) {
        await _endAuction(FirebaseFirestore.instance
            .collection('auctions')
            .doc(widget.itemId));
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
      _notifyWinner(winner);
    }
  }

  Future<void> _notifySeller(String sellerId, String winnerId) async {
    final sellerDoc =
        FirebaseFirestore.instance.collection('users').doc(sellerId);
    await sellerDoc.collection('notifications').add({
      'title': 'Leilão encerrado',
      'message': 'Seu leilão terminou. O vencedor é o usuário $winnerId.',
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _notifyWinner(String winnerId) async {
    final winnerDoc =
        FirebaseFirestore.instance.collection('users').doc(winnerId);
    await winnerDoc.collection('notifications').add({
      'title': 'Você venceu o leilão!',
      'message': 'Parabéns, você venceu o leilão!',
      'timestamp': Timestamp.now(),
    });
  }

  void _startCountdown(DocumentReference auctionDoc) {
    int secondsLeft = 60;

    _countdownTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      secondsLeft -= 10;
      if (secondsLeft <= 0) {
        await _endAuction(auctionDoc);
        timer.cancel();
      } else {
        _showNotification('O leilão está terminando em $secondsLeft segundos!');
        _showPopup(
            context, 'O leilão está terminando em $secondsLeft segundos!');
      }
    });
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  String _formatTimeRemaining() {
    if (endTime == null) return "00:00:00";
    final Duration remaining = endTime!.difference(DateTime.now());
    if (remaining.isNegative) {
      return "00:00:00";
    }
    final String hours = remaining.inHours.toString().padLeft(2, '0');
    final String minutes =
        (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds =
        (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
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
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isSeller == null) {
            // Mostra o indicador de carregamento se os dados ainda estiverem carregando
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

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

          // Calculando os lances automáticos
          final double startingBid = auctionData['startingBid'];
          final double bidIncrement = 50.0;
          final double bid1 = startingBid + bidIncrement;
          final double bid2 = startingBid + 2 * bidIncrement;
          final double instantBid = startingBid + 3 * bidIncrement;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Produto
                  Image.network(
                    auctionData['imagePath'],
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),

                  // Nome do produto e detalhes do vendedor
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auctionData['productName'] ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/default_profile.jpg'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            auctionData['seller'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Preço inicial e preço atual
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceInfo(
                          'Preço Inicial', auctionData['startingBid']),
                      _buildPriceInfo('Preço Atual', auctionData['currentBid']),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Contador de tempo restante
                  if (!isEnded)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/default_profile.jpg'),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'em live',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          _formatTimeRemaining(),
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

                  // Lances e lista de lances
                  const Text(
                    'Lances',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildBidList(auctionData['bids']),
                  const SizedBox(height: 20),

                  // Participantes ao vivo
                  _buildLiveParticipants(liveParticipants),

                  const SizedBox(height: 20),

                  // Seção de lances
                  if (!isEnded && !isSeller)
                    _buildBidSection(auctionData, bid1, bid2, instantBid),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildBidList(List<dynamic> bids) {
    if (bids == null || bids.isEmpty) {
      return const Text('Nenhum lance até o momento.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bids.length,
      itemBuilder: (context, index) {
        final bid = bids[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/default_profile.jpg'),
          ),
          title: Text(currentUserName ?? 'Usuário'),
          subtitle: Text('R\$ ${bid['bidAmount'].toStringAsFixed(2)}'),
          trailing: Text(_formatTimeSince(bid['timestamp'])),
        );
      },
    );
  }

  Widget _buildLiveParticipants(List<String> participants) {
    if (participants == null || participants.isEmpty) {
      return const Text(
        'Nenhum participante ao vivo no momento.',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Participantes ao vivo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (participants.isEmpty)
          const Text('Nenhum participante ao vivo no momento.'),
        if (participants.isNotEmpty)
          Wrap(
            children: participants.map((userId) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/default_profile.jpg'),
                    );
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/default_profile.jpg'),
                    );
                  }

                  final userDoc = snapshot.data!;
                  final profileImageUrl = userDoc['profileImageUrl'] ??
                      'assets/images/default_profile.jpg';

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundImage: profileImageUrl.startsWith('http')
                          ? NetworkImage(profileImageUrl)
                          : AssetImage(profileImageUrl) as ImageProvider,
                    ),
                  );
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  String _formatTimeSince(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 1) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inDays == 1) {
      return '1 dia atrás';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inHours == 1) {
      return '1 hora atrás';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutos atrás';
    } else if (difference.inMinutes == 1) {
      return '1 minuto atrás';
    } else {
      return 'Agora mesmo';
    }
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
          'R\$ ${price.toStringAsFixed(2)}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildBidSection(Map<String, dynamic> auctionData, double bid1,
      double bid2, double instantBid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildBidButton('R\$${bid1.toStringAsFixed(2)}', bid1),
            _buildBidButton('R\$${bid2.toStringAsFixed(2)}', bid2),
            _buildInstantBidButton(
                'R\$${instantBid.toStringAsFixed(2)}', instantBid),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _showCustomBidDialog(context, instantBid);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A3497),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Lance Customizado'),
        ),
      ],
    );
  }

  void _showCustomBidDialog(BuildContext context, double maxBid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lance Customizado'),
          content: TextField(
            controller: _customBidController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            decoration: const InputDecoration(
              labelText: 'Digite seu lance',
              prefixText: 'R\$ ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final double customBid = double.parse(
                    _customBidController.text.replaceAll(',', '.'));
                _placeBid(customBid);
                if (customBid > maxBid) {
                  _startCountdown(FirebaseFirestore.instance
                      .collection('auctions')
                      .doc(widget.itemId));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar Lance'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstantBidButton(String label, double bidAmount) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _showBidConfirmationDialog(context, bidAmount, true);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red),
            color: Colors.red,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkIfSeller() async {
    final sellerId = await this.sellerId;
    if (sellerId == currentUserId) {
      print('O usuário atual é o vendedor do leilão.');
      return true;
    } else {
      print('O usuário atual não é o vendedor.');
      return false;
    }
  }

  // Getter para retornar o vendedor do leilão
  Future<String?> get sellerId async {
    if (_sellerId != null) {
      return _sellerId;
    }

    try {
      final auctionDoc = await FirebaseFirestore.instance
          .collection('auctions')
          .doc(widget.itemId)
          .get();

      if (auctionDoc.exists) {
        final auctionData = auctionDoc.data() as Map<String, dynamic>?;
        _sellerId = auctionData?['sellerId'];
        return _sellerId;
      }
    } catch (e) {
      print('Erro ao buscar o vendedor: $e');
    }

    return null;
  }

  Widget _buildBidButton(String label, double? bidAmount) {
    // Verifica se já temos a informação se é vendedor
    if (_isSeller == null) {
      return const CircularProgressIndicator(); // Ou outro indicador de carregamento
    }

    return Expanded(
      child: GestureDetector(
        onTap: _isSeller!
            ? null
            : () {
                if (bidAmount != null) {
                  _showBidConfirmationDialog(context, bidAmount, false);
                }
              },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _isSeller! ? Colors.grey : Colors.black),
            color: _isSeller! ? Colors.grey[300] : Colors.white,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: _isSeller! ? Colors.grey : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  void _showBidConfirmationDialog(
      BuildContext context, double bidAmount, bool isInstantBid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lance Feito'),
          content: Text(
              'Você deu um lance de R\$ ${bidAmount.toStringAsFixed(2)}. Confirma este lance?'),
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
                if (isInstantBid || bidAmount > bidAmount) {
                  _startCountdown(FirebaseFirestore.instance
                      .collection('auctions')
                      .doc(widget.itemId));
                }
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
    try {
      final docRef =
          FirebaseFirestore.instance.collection('auctions').doc(widget.itemId);
      final auctionData = await docRef.get();

      if (auctionData.exists) {
        final auctionDetails = auctionData.data() as Map<String, dynamic>;
        final sellerId = auctionDetails['sellerId'];
        // Obtém o lance atual, ou 0.0 se não existir
        final currentBid = auctionDetails['currentBid'] as double? ?? 0.0;

        // Prints para debug
        print('currentUserId: $currentUserId');
        print('sellerId: $sellerId');
        print('currentBid: $currentBid');

        // Verificar se o vendedor está tentando dar um lance
        if (currentUserId == sellerId) {
          // Exibir uma mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você não pode dar lances no seu próprio leilão.'),
            ),
          );
          return;
        }

        // Verificar se o lance é menor que o maior lance atual
        if (bidAmount <= currentBid) {
          // Exibir uma mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seu lance deve ser maior que o lance atual.'),
            ),
          );
          return;
        }

        final bidData = {
          'userId': currentUserId!,
          'bidAmount': bidAmount,
          'timestamp': Timestamp.now(),
        };

        // Atualizar o lance no Firestore
        await docRef.update({
          'currentBid': bidAmount,
          'bids': FieldValue.arrayUnion([bidData]),
        });

        // Exibir confirmação de lance
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lance feito com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: Leilão não encontrado.'),
          ),
        );
      }
    } catch (e) {
      print('Erro ao fazer o lance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao tentar fazer o lance.'),
        ),
      );
    }
  }
}
