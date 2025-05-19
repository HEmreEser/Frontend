import 'package:flutter/material.dart';
import 'features/auth/auth_service.dart';
import 'features/profile/my_account_page.dart';
import 'features/rental/my_rentals_page.dart';

// Beispiel einer einfachen LoginPage, du kannst sie natürlich anpassen!
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? error;

  Future<void> _login() async {
    setState(() => error = null);
    try {
      await AuthService().login(
        emailController.text.trim(),
        passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    } catch (e) {
      setState(() => error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: _login, child: const Text('Einloggen')),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getInitialRoute() async {
    final token = await AuthService.getToken();
    return (token != null && token.isNotEmpty) ? '/account' : '/login';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        String initialRoute = '/login';
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          initialRoute = snapshot.data!;
        }
        return MaterialApp(
          title: 'Verleih App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          initialRoute: initialRoute,
          routes: {
            '/login': (context) => const LoginPage(),
            '/account': (context) => const MyAccountPage(),
            '/rentals': (context) => const MyRentalsPage(),
          },
        );
      },
    );
  }
}
