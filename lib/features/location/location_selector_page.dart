import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider für den Standort
final selectedLocationProvider = StateProvider<String?>((ref) => null);

class LocationSelectorPage extends ConsumerWidget {
  const LocationSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedLocationProvider);

    // Hilfsfunktion: Standort setzen und immer zur Startseite
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
            onPressed: () => selectLocation('Lothstraße'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selected == 'Lothstraße' ? Colors.blueAccent : null,
            ),
            child: const Text('Lothstraße'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => selectLocation('Pasing'),
            style: ElevatedButton.styleFrom(
              backgroundColor: selected == 'Pasing' ? Colors.blueAccent : null,
            ),
            child: const Text('Pasing'),
          ),
        ],
      ),
    );
  }
}
