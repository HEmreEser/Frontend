import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth_service.dart'; // <-- Passe diesen Import ggf. an!

class MyRentalsPage extends StatefulWidget {
  const MyRentalsPage({super.key});

  @override
  State<MyRentalsPage> createState() => _MyRentalsPageState();
}

class _MyRentalsPageState extends State<MyRentalsPage> {
  List<dynamic> rentals = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  Future<void> _loadRentals() async {
    setState(() {
      loading = true;
      error = null;
    });

    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      // Nicht eingeloggt, weiterleiten!
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/rentals/my'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          rentals = json.decode(response.body);
        });
      } else if (response.statusCode == 401) {
        // Token abgelaufen oder ungültig: weiterleiten
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        setState(() {
          error =
              'Fehler beim Laden deiner Ausleihen (Status ${response.statusCode})';
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(body: Center(child: Text(error!)));
    }
    if (rentals.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Keine Ausleihen gefunden.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Ausleihen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Abmelden",
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: rentals.length,
        itemBuilder: (context, index) {
          final rental = rentals[index];
          return ListTile(
            title: Text(rental['equipmentName'] ?? ''),
            subtitle: Text(
              'Von: ${rental['startDate']} bis ${rental['endDate']}',
            ),
          );
        },
      ),
    );
  }
}
