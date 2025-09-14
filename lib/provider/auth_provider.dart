// auth_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase.services.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  User? _user;

  AuthProvider() {
    _user = _supabaseService.currentUser;
    // Listen to Supabase auth state changes and update the internal state
    _supabaseService.authState.listen((data) {
      _user = data.session?.user;
      // Notify listeners of any change in the authentication state
      notifyListeners();
    });
  }

  // A getter to provide the current user state
  User? get user => _user;

  // A getter to provide the current auth state for more granular control
  Stream<AuthState> get authStateChanges => _supabaseService.authState;

  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    await _supabaseService.signIn(email, password);
  }

  Future<void> signup(String email, String password, String fullName) async {
    await _supabaseService.signUp(email, password, fullName);
  }

  Future<void> logout() async {
    await _supabaseService.signOut();
  }
}
