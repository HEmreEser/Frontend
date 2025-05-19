import 'package:flutter/material.dart';
import '../../models/user_response.dart';
import '../../services/user_service.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    // Beispiel für einfachen Logout: Token löschen und zur Login-Seite navigieren
    // Hier solltest du stattdessen dein echtes Auth-Handling nutzen!
    // z.B. SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mein Konto")),
      body: FutureBuilder<UserResponse>(
        future: UserService().fetchMyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text("Fehler beim Laden deines Profils."),
            );
          }
          final profile = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${profile.name}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("E-Mail: ${profile.email}"),
                Text(
                  "Registriert seit: ${profile.createdAt.toLocal().toString().split(" ").first}",
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
