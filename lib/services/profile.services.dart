import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Create a new profile row for the user (optional, can be done on sign-up)
  Future<void> createProfileRow(String userId) async {
    await _client.from('profiles').insert({
      'id': userId,
      'setup_complete': false,
    });
  }

  /// Save step 1 interests (like Hollywood/Bollywood)
  Future<void> saveInterests(String userId, List<String> interests) async {
    // Check if the profile exists
    final existingProfile = await fetchProfile(userId);

    // If profile have not been created yet, create one.
    if (existingProfile == null) {
      await createProfileRow(userId);
    }

    await _client
        .from('profiles')
        .update({'interests': interests})
        .eq('id', userId);
  }

  /// Save step 2 genres
  Future<void> saveGenres(String userId, List<String> genres) async {
    // Check if the profile exists
    final existingProfile = await fetchProfile(userId);

    // If profile have not been created yet, create one.
    if (existingProfile == null) {
      await createProfileRow(userId);
    }

    await _client.from('profiles').update({'genres': genres}).eq('id', userId);
  }

  /// Mark onboarding finished
  Future<void> markSetupComplete(String userId) async {
    await _client
        .from('profiles')
        .update({'setup_complete': true})
        .eq('id', userId);
  }

  /// Check if profile setup is done
  Future<bool> isProfileComplete(String userId) async {
    final res = await _client
        .from('profiles')
        .select('setup_complete')
        .eq('id', userId)
        .maybeSingle();
    if (res == null) return false;
    return (res['setup_complete'] ?? false) as bool;
  }

  /// fetch entire profile row
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return profile;
  }
}
