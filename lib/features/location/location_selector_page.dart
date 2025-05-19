import 'package:flutter/material.dart';

class LocationSelectorPage extends StatelessWidget {
  const LocationSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Später hier echte Logik/Backend-Call
    return Scaffold(
      appBar: AppBar(title: const Text('Standort wählen')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ElevatedButton(
            onPressed: () {
              /* Weiter zur Hauptseite mit Location "Pasing" */
            },
            child: const Text('Pasing'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              /* Weiter zur Hauptseite mit Location "Lothstraße" */
            },
            child: const Text('Lothstraße'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              /* Weiter zur Hauptseite mit Location "Karlstraße" */
            },
            child: const Text('Karlstraße'),
          ),
        ],
      ),
    );
  }
}
