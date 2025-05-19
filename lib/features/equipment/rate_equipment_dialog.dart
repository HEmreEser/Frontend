import 'package:flutter/material.dart';
import '../../models/equipment_response.dart';
import '../../services/rating_service.dart';

class RateEquipmentDialog extends StatefulWidget {
  final EquipmentResponse equipment;

  const RateEquipmentDialog({Key? key, required this.equipment})
    : super(key: key);

  @override
  State<RateEquipmentDialog> createState() => _RateEquipmentDialogState();
}

class _RateEquipmentDialogState extends State<RateEquipmentDialog> {
  int _selectedStars = 5;
  final TextEditingController _commentController = TextEditingController();
  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await RatingService().submitRating(
        equipmentId: widget.equipment.id,
        stars: _selectedStars,
        comment:
            _commentController.text.isNotEmpty ? _commentController.text : null,
      );
      Navigator.of(context).pop(true); // Bewertung erfolgreich abgegeben
    } catch (e) {
      setState(() {
        _error = "Fehler beim Absenden: $e";
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Gerät bewerten"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Wie viele Sterne gibst du?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color:
                      _selectedStars >= starIndex ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _selectedStars = starIndex;
                  });
                },
              );
            }),
          ),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(labelText: "Kommentar (optional)"),
            maxLines: 3,
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: Text("Abbrechen"),
        ),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          child:
              _submitting
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  )
                  : Text("Abschicken"),
        ),
      ],
    );
  }
}
