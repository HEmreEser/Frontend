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
      String url = 'http://localhost:8080/api/equipment';
      Map<String, String> params = {};

      // Kategorie-Filter nur setzen, wenn nicht 'Alle'
      if (selectedCategory != 'Alle') {
        params['categoryId'] = categoryToId(selectedCategory).toString();
      }
      if (onlyAvailable) {
        params['available'] = 'true';
      }

      if (params.isNotEmpty) {
        url =
            'http://localhost:8080/api/equipment/filter?' +
            params.entries.map((e) => '${e.key}=${e.value}').join('&');
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
          ],
        ),
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final eq = filtered[index];
                  return ListTile(
                    title: Text(eq['name'] ?? ''),
                    subtitle: Text(
                      '${eq['categoryName'] ?? ''} | ${eq['locationName'] ?? ''}',
                    ),
                    trailing: eq['available'] ? const Icon(Icons.check) : null,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/equipmentdetail',
                        arguments: {'id': eq['id']},
                      );
                    },
                  );
                },
              ),
    );
  }
}
