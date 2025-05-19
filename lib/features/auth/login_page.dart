import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider.select((s) => s.loading));
    final error = ref.watch(authProvider.select((s) => s.error));

    return Scaffold(
      appBar: AppBar(title: const Text('Anmeldung')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'HM E-Mail',
                hintText: 'z.B. student1@hm.edu',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            if (error != null) ...[
              const SizedBox(height: 16),
              Text(error, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  loading
                      ? null
                      : () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text;
                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@hm\.edu$',
                        ).hasMatch(email)) {
                          ref
                              .read(authProvider.notifier)
                              .setError('Nur HM-E-Mail-Adressen sind erlaubt!');
                          return;
                        }
                        final result = await ref
                            .read(authProvider.notifier)
                            .login(email, password);
                        if (result && mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/location');
                        }
                      },
              child:
                  loading
                      ? const CircularProgressIndicator()
                      : const Text('Anmelden'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
              child: const Text('Noch keinen Account? Jetzt registrieren'),
            ),
          ],
        ),
      ),
    );
  }
}
