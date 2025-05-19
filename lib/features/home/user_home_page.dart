import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String search = '';
  String selectedCategory = 'Alle';
  bool onlyAvailable = true;
  List<dynamic> equipments = [];
  bool loading = false;
  String? error;

  final categories = [
    'Alle',
    'Draußensport',
    'Innensport',
    'Fortbewegungsmittel',
    'Kleidung',
  ];

  @override
  void initState() {
    super.initState();
    fetchEquipments();
  }

  Future<void> fetchEquipments() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // Backend-URL anpassen!
      String url = 'http://localhost:8080/api/equipment';
      // Kategorie-Filter
      if (selectedCategory != 'Alle') {
        url =
            'http://localhost:8080/api/equipment/category/${categoryToId(selectedCategory)}';
      }
      // Optional: Verfügbarkeit filtern (wenn Backend-Endpunkt vorhanden)
      // Hier Beispiel: ?available=true
      if (onlyAvailable && selectedCategory == 'Alle') {
        url = 'http://localhost:8080/api/equipment/filter?available=true';
      } else if (onlyAvailable && selectedCategory != 'Alle') {
        url =
            'http://localhost:8080/api/equipment/filter?categoryId=${categoryToId(selectedCategory)}&available=true';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          equipments = data;
        });
      } else {
        setState(() {
          error = 'Fehler beim Laden (Status ${response.statusCode})';
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

  // Mapping für deine Kategorien zu Backend-IDs (hier beispielhaft)
  int categoryToId(String cat) {
    switch (cat) {
      case 'Draußensport':
        return 1;
      case 'Innensport':
        return 2;
      case 'Fortbewegungsmittel':
        return 3;
      case 'Kleidung':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Suche und Filter lokal anwenden
    final filtered =
        equipments
            .where(
              (eq) =>
                  (search.isEmpty ||
                      (eq['name'] as String).toLowerCase().contains(
                        search.toLowerCase(),
                      )),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment-Verleih'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/account'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menü')),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Meine Ausleihen'),
              onTap: () => Navigator.pushNamed(context, '/myrentals'),
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text('Mein Konto'),
              onTap: () => Navigator.pushNamed(context, '/account'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Abmelden'),
              onTap: () {
                // Token löschen etc.
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (r) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Suchen...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (val) => setState(() {
                    search = val;
                  }),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories
                        .map(
                          (cat) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: selectedCategory == cat,
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = cat;
                                });
                                fetchEquipments();
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Nur verfügbare anzeigen"),
                Switch(
                  value: onlyAvailable,
                  onChanged: (val) {
                    setState(() {
                      onlyAvailable = val;
                    });
                    fetchEquipments();
                  },
                ),
              ],
            ),
            const Divider(),
            if (loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (error != null)
              Expanded(child: Center(child: Text(error!)))
            else
              Expanded(
                child:
                    filtered.isEmpty
                        ? const Center(child: Text('Keine Ergebnisse'))
                        : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) {
                            final eq = filtered[idx];
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  (eq['available'] ?? true)
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color:
                                      (eq['available'] ?? true)
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                title: Text(eq['name'] ?? ''),
                                subtitle: Text(
                                  '${eq['category']['name'] ?? ''} • ${eq['description'] ?? ''}',
                                ),
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/equipmentdetail',
                                      arguments: eq,
                                    ),
                              ),
                            );
                          },
                        ),
              ),
          ],
        ),
      ),
      floatingActionButton: null,
    );
  }
}
