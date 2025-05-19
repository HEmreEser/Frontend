import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

class AuthState {
  final bool loading;
  final String? error;
  final String? token;

  AuthState({this.loading = false, this.error, this.token});

  AuthState copyWith({bool? loading, String? error, String? token}) =>
      AuthState(
        loading: loading ?? this.loading,
        error: error,
        token: token ?? this.token,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  AuthNotifier(this.authService) : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = await authService.login(email, password);
      state = AuthState(loading: false, token: token, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = await authService.register(email, password);
      state = AuthState(loading: false, token: token, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthService()),
);
