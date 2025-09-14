import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // Login with email and password
  Future<AuthResponse> signIn(String email, String password) {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign up with email and password
  Future<AuthResponse> signUp(String email, String password, String fullName) {
    return supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  // Logout
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Get current user
  User? get currentUser => supabase.auth.currentUser;

  // Stream of auth changes
  Stream<AuthState> get authState => supabase.auth.onAuthStateChange;
}
