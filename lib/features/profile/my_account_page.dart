import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart'; // <-- Passe diesen Import ggf. an!

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  Map<String, dynamic>? profile;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      loading = true;
      error = null;
    });

    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/profile/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          profile = json.decode(response.body);
        });
      } else if (response.statusCode == 401) {
        if (mounted) {
          await AuthService.logout();
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        setState(() {
          error =
              'Fehler beim Laden deines Profils (Status ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Fehler: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // <- HIER ist die einfache Abmelde-Funktion
  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mein Konto')),
        body: Center(child: Text(error!)),
      );
    }
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mein Konto')),
        body: const Center(child: Text('Profil nicht gefunden.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Konto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('E-Mail: ${profile!['email'] ?? ""}'),
            // Weitere Profildaten falls vorhanden...
            const SizedBox(height: 32),
            // <- HIER steht der einfache Abmelde-Button
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Abmelden'),
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
