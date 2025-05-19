import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/login_page.dart';
import 'features/auth/registration_page.dart';
import 'features/location/location_selector_page.dart';
import 'features/home/user_home_page.dart';
import 'features/profile/my_account_page.dart';
import 'features/rental/my_rentals_page.dart';
import 'features/equipment/equipment_detail_page.dart';
// import 'features/home/admin_home_page.dart'; // Falls vorhanden, sonst auskommentieren oder erstellen!

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equipment Verleih',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/equipmentdetail') {
          final args = settings.arguments;
          int? equipmentId;
          if (args is int) {
            equipmentId = args;
          } else if (args is Map && args['id'] is int) {
            equipmentId = args['id'] as int;
          } else if (args is Map &&
              args['equipment'] != null &&
              args['equipment']['id'] is int) {
            equipmentId = args['equipment']['id'] as int;
          }
          if (equipmentId != null) {
            return MaterialPageRoute(
              builder:
                  (context) => EquipmentDetailPage(equipmentId: equipmentId!),
            );
          } else {
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(
                      child: Text('Fehler: Equipment-ID nicht gefunden'),
                    ),
                  ),
            );
          }
        }
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegistrationPage());
          case '/location':
            return MaterialPageRoute(
              builder: (_) => const LocationSelectorPage(),
            );
          case '/':
            return MaterialPageRoute(builder: (_) => const UserHomePage());
          case '/account':
            return MaterialPageRoute(builder: (_) => const MyAccountPage());
          case '/myrentals':
            return MaterialPageRoute(builder: (_) => const MyRentalsPage());
          // case '/admin':
          //   return MaterialPageRoute(builder: (_) => const AdminHomePage()); // Nur falls Widget existiert!
          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('Seite nicht gefunden')),
                  ),
            );
        }
      },
    );
  }
}
