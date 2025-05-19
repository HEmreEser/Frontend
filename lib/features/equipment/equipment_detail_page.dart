import 'package:flutter/material.dart';
import '../../models/equipment_response.dart';
import '../../models/rating_response.dart';
import '../../services/equipment_service.dart';
import '../../services/rating_service.dart';
import 'rent_equipment_dialog.dart';
import 'rate_equipment_dialog.dart';

class EquipmentDetailPage extends StatefulWidget {
  final int equipmentId;

  const EquipmentDetailPage({Key? key, required this.equipmentId})
    : super(key: key);

  @override
  State<EquipmentDetailPage> createState() => _EquipmentDetailPageState();
}

class _EquipmentDetailPageState extends State<EquipmentDetailPage> {
  late Future<EquipmentResponse> equipmentFuture;
  late Future<List<RatingResponse>> ratingsFuture;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    equipmentFuture = EquipmentService().fetchEquipmentDetail(
      widget.equipmentId,
    );
    ratingsFuture = RatingService().fetchRatingsForEquipment(
      widget.equipmentId,
    );
  }

  void _showRentDialog(EquipmentResponse equipment) async {
    final rented = await showDialog<bool>(
      context: context,
      builder: (_) => RentEquipmentDialog(equipment: equipment),
    );
    if (rented == true) {
      setState(() {
        _reloadData();
      });
    }
  }

  void _showRateDialog(EquipmentResponse equipment) async {
    final rated = await showDialog<bool>(
      context: context,
      builder: (_) => RateEquipmentDialog(equipment: equipment),
    );
    if (rated == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Danke für deine Bewertung!")),
      );
      setState(() {
        ratingsFuture = RatingService().fetchRatingsForEquipment(equipment.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerätedetails")),
      body: FutureBuilder<EquipmentResponse>(
        future: equipmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Fehler beim Laden des Geräts"));
          }
          final equipment = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                equipment.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text("Kategorie: ${equipment.categoryName}"),
              Text("Standort: ${equipment.locationName}"),
              Text(
                "Beschreibung: ${equipment.description.isNotEmpty ? equipment.description : '-'}",
              ),
              Text(
                "Status: ${equipment.available ? 'Verfügbar' : 'Verliehen'}",
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          equipment.available
                              ? () => _showRentDialog(equipment)
                              : null,
                      child: const Text("Ausleihen"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRateDialog(equipment),
                      icon: const Icon(Icons.star),
                      label: const Text("Bewerten"),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(
                "Bewertungen:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<RatingResponse>>(
                future: ratingsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snap.hasError) {
                    return const Text("Fehler beim Laden der Bewertungen");
                  }
                  if (!snap.hasData || snap.data!.isEmpty) {
                    return const Text("Noch keine Bewertung.");
                  }
                  return Column(
                    children:
                        snap.data!
                            .map(
                              (r) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  title: Text("${r.stars} ★"),
                                  subtitle: Text(r.comment ?? ""),
                                  trailing: Text(r.userName),
                                ),
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
