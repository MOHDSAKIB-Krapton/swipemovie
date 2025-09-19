import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> nativeGoogleSignIn() async {
    const webClientId =
        '604691048172-opkmpevcn47csfsk0kfdgt2l1tcj7oh9.apps.googleusercontent.com';
    const iosClientId =
        '604691048172-4ussr4jg4kgbikjo0v5h0vqbksjbkp1i.apps.googleusercontent.com';

    final scopes = ['email', 'profile'];

    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId: webClientId,
      clientId: iosClientId,
    );
    final googleUser = await googleSignIn.attemptLightweightAuthentication();
    // or await googleSignIn.authenticate(); which will return a GoogleSignInAccount or throw an exception
    if (googleUser == null) {
      throw AuthException('Failed to sign in with Google.');
    }

    /// Authorization is required to obtain the access token with the appropriate scopes for Supabase authentication,
    /// while also granting permission to access user information.
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
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
