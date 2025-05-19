import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider.select((s) => s.loading));
    final error = ref.watch(authProvider.select((s) => s.error));

    return Scaffold(
      appBar: AppBar(title: const Text('Registrieren')),
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
            const SizedBox(height: 16),
            TextField(
              controller: passwordRepeatController,
              decoration: const InputDecoration(
                labelText: 'Passwort wiederholen',
              ),
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
                        final passwordRepeat = passwordRepeatController.text;
                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@hm\.edu$',
                        ).hasMatch(email)) {
                          ref
                              .read(authProvider.notifier)
                              .setError('Nur HM-E-Mail-Adressen sind erlaubt!');
                          return;
                        }
                        if (password.length < 6) {
                          ref
                              .read(authProvider.notifier)
                              .setError(
                                'Passwort muss mindestens 6 Zeichen haben!',
                              );
                          return;
                        }
                        if (password != passwordRepeat) {
                          ref
                              .read(authProvider.notifier)
                              .setError('Passwörter stimmen nicht überein!');
                          return;
                        }
                        final result = await ref
                            .read(authProvider.notifier)
                            .register(email, password);
                        if (result && mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/location');
                        }
                      },
              child:
                  loading
                      ? const CircularProgressIndicator()
                      : const Text('Registrieren'),
            ),
          ],
        ),
      ),
    );
  }
}
