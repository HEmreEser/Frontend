import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthState {
  final bool loading;
  final String? error;
  final String? token;
  AuthState({this.loading = false, this.error, this.token});

  AuthState copyWith({bool? loading, String? error, String? token}) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setError(String message) {
    state = state.copyWith(loading: false, error: message);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = await AuthService().login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      state = AuthState(token: token, loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = await AuthService().register(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      state = AuthState(token: token, loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = AuthState();
  }
}
