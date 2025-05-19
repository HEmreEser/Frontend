import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../location/location_selector_page.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({super.key});

  @override
  ConsumerState<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends ConsumerState<UserHomePage> {
  List<dynamic> equipments = [];
  bool loading = false;
  String? error;
  String?
  lastLocation; // Damit wir nur neu laden, wenn der Standort sich ändert

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeLoadEquipments();
  }

  @override
  void didUpdateWidget(covariant UserHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeLoadEquipments();
  }

  void _maybeLoadEquipments() {
    final location = ref.read(selectedLocationProvider);
    if (location != lastLocation) {
      lastLocation = location;
      _loadEquipments(location);
    }
  }

  Future<void> _loadEquipments(String? locationName) async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      String url = 'http://localhost:8080/api/equipment/filter?';
      if (locationName != null && locationName.isNotEmpty) {
        url += 'locationName=${Uri.encodeComponent(locationName)}';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          equipments = json.decode(response.body);
        });
      } else {
        setState(() {
          error = 'Fehler beim Laden (${response.statusCode})';
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
    final location = ref.watch(selectedLocationProvider);

    // Wenn kein Standort gewählt wurde, zur Auswahlseite leiten
    if (location == null || location.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/location');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment (${location})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            tooltip: "Standort ändern",
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/location');
            },
          ),
        ],
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : equipments.isEmpty
              ? const Center(child: Text('Keine Geräte gefunden.'))
              : ListView.builder(
                itemCount: equipments.length,
                itemBuilder: (context, index) {
                  final eq = equipments[index];
                  return ListTile(
                    title: Text(eq['name'] ?? ''),
                    subtitle: Text(
                      '${eq['categoryName'] ?? ''} | ${eq['locationName'] ?? ''}',
                    ),
                    trailing:
                        eq['available'] == true
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.close, color: Colors.red),
                  );
                },
              ),
    );
  }
}
