import 'package:flutter/material.dart';
import '../../models/rental_response.dart';
import '../../services/rental_service.dart';
import 'package:intl/intl.dart';

class MyRentalsPage extends StatefulWidget {
  const MyRentalsPage({Key? key}) : super(key: key);

  @override
  State<MyRentalsPage> createState() => _MyRentalsPageState();
}

class _MyRentalsPageState extends State<MyRentalsPage> {
  late Future<List<RentalResponse>> myRentalsFuture;

  @override
  void initState() {
    super.initState();
    myRentalsFuture = RentalService().fetchMyRentals();
  }

  Future<void> _returnRental(int rentalId) async {
    try {
      await RentalService().returnRental(rentalId);
      setState(() {
        myRentalsFuture = RentalService().fetchMyRentals();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler beim Zurückgeben: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meine Ausleihen")),
      body: FutureBuilder<List<RentalResponse>>(
        future: myRentalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Fehler: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Keine Ausleihen gefunden."));
          }
          final rentals = snapshot.data!;
          return ListView.builder(
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(rental.equipmentName),
                  subtitle: Text(
                    "Von ${DateFormat.yMd().format(rental.startDate)} bis ${DateFormat.yMd().format(rental.endDate)}\nStatus: ${rental.returned ? 'Zurückgegeben' : 'Ausgeliehen'}",
                  ),
                  trailing:
                      !rental.returned
                          ? TextButton(
                            onPressed:
                                () async => await _returnRental(rental.id),
                            child: const Text("Zurückgeben"),
                          )
                          : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
