import 'package:clo/firebase_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home/tela_home.dart'; // Importe a tela inicial para onde o usuário logado será redirecionado
import 'onboarding/bem_vindo.dart';
import 'onboarding/onboarding_screen1.dart';
import 'onboarding/onboarding_screen2.dart';
import 'onboarding/onboarding_screen3.dart';
import 'onboarding/tela_abertura.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clo Leilões',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          const MainWrapper(), // Altere para MainWrapper, onde você verifica o estado de autenticação
      routes: {
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/onboarding3': (context) => const OnboardingScreen3(),
        '/login': (context) => const BemVindoScreen(),
        '/home': (context) => const HomeScreen(), // Tela inicial após login
      },
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  bool _hasConnection = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    _connectionStatus = await _connectivity.checkConnectivity();
    _hasConnection = _connectionStatus != ConnectivityResult.none;

    if (_hasConnection) {
      _checkAuthStatus();
    } else {
      setState(() {
        _isLoading = false;
      });
      _showNoConnectionDialog();
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Se o usuário está autenticado, vá para a tela inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Se o usuário não está autenticado, vá para a tela de boas-vindas ou login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaAbertura()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showAuthErrorDialog(e.message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sem Conexão'),
        content: const Text(
            'Você está offline. Verifique sua conexão com a internet e tente novamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkConnection(); // Tentar reconectar
            },
            child: const Text('Tentar Novamente'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context); // Fazer logout e voltar para a tela de login
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showAuthErrorDialog(String? errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro de Autenticação'),
        content: Text(errorMessage ?? 'Ocorreu um erro ao verificar o login.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkAuthStatus(); // Tentar novamente a verificação de autenticação
            },
            child: const Text('Tentar Novamente'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context); // Fazer logout e voltar para a tela de login
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Redireciona para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text('Carregando...'),
        ),
      );
    }
  }
}
