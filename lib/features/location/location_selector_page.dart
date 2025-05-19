import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple Provider (du kannst stattdessen auch SharedPreferences nehmen)
final selectedLocationProvider = StateProvider<String?>((ref) => null);

class LocationSelectorPage extends ConsumerWidget {
  const LocationSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void selectLocation(String location) {
      ref.read(selectedLocationProvider.notifier).state = location;
      Navigator.of(context).pushReplacementNamed('/');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Standort wählen')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ElevatedButton(
            onPressed: () => selectLocation('Pasing'),
            child: const Text('Pasing'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => selectLocation('Lothstraße'),
            child: const Text('Lothstraße'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => selectLocation('Karlstraße'),
            child: const Text('Karlstraße'),
          ),
        ],
      ),
    );
  }
}
