import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
import '../../models/user_response.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late Future<UserResponse> myProfileFuture;

  @override
  void initState() {
    super.initState();
    myProfileFuture = _fetchProfile();
  }

  Future<UserResponse> _fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception("Du bist nicht eingeloggt.");
    }
    return await UserService().fetchMyProfile(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Konto')),
      body: FutureBuilder<UserResponse>(
        future: myProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Fehler: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Keine Profildaten gefunden."));
          }
          final user = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Name: ${user.name}'),
              Text('E-Mail: ${user.email}'),
              Text('Rolle: ${user.role}'),
              // Weitere Felder je nach Backend-Response ergänzen
            ],
          );
        },
      ),
    );
  }
}
