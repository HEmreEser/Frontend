import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/equipment_response.dart';
import '../../services/rental_service.dart';

class RentEquipmentDialog extends StatefulWidget {
  final EquipmentResponse equipment;

  const RentEquipmentDialog({Key? key, required this.equipment})
    : super(key: key);

  @override
  State<RentEquipmentDialog> createState() => _RentEquipmentDialogState();
}

class _RentEquipmentDialogState extends State<RentEquipmentDialog> {
  DateTime? startDate;
  DateTime? endDate;
  bool loading = false;
  String? error;

  Future<void> _submit() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await RentalService().rentEquipment(
        equipmentId: widget.equipment.id!,
        startDate: startDate!,
        endDate: endDate!,
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        error = "Fehler beim Ausleihen: $e";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ausleihe anlegen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Gerät: ${widget.equipment.name}"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      initialDate: startDate ?? DateTime.now(),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                  child: Text(
                    startDate != null
                        ? DateFormat.yMd().format(startDate!)
                        : "Startdatum wählen",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      initialDate: endDate ?? (startDate ?? DateTime.now()),
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
                  child: Text(
                    endDate != null
                        ? DateFormat.yMd().format(endDate!)
                        : "Enddatum wählen",
                  ),
                ),
              ),
            ],
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Abbrechen"),
        ),
        ElevatedButton(
          onPressed:
              loading ||
                      startDate == null ||
                      endDate == null ||
                      endDate!.isBefore(startDate!)
                  ? null
                  : _submit,
          child:
              loading
                  ? const CircularProgressIndicator()
                  : const Text("Ausleihen"),
        ),
      ],
    );
  }
}
