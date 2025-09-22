import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipemovie/services/profile.services.dart';

class MoviesService {
  final SupabaseClient _client = Supabase.instance.client;

  // Future<List<Map<String, dynamic>>> fetchInitialMovies() async {
  //   final data = await _client
  //       .from('movies')
  //       .select()
  //       .not('primary_image_url', 'is', null)
  //       .limit(20);
  //   return data;
  // }

  Future<List<Map<String, dynamic>>> fetchInitialMovies(String userId) async {
    final profile = await ProfileService().fetchProfile(userId);

    if (profile == null || profile['genres'] == null) {
      // fallback: return 20 movies with images if interests are not set
      final fallback = await _client
          .from('movies')
          .select()
          .not('primary_image_url', 'is', null)
          .limit(20);
      return fallback;
    }

    final List<String> userGenres = List<String>.from(profile['genres']);

    // Fetch movies that have at least one genre matching the user's genres
    final movies = await _client
        .from('movies')
        .select()
        .not('primary_image_url', 'is', null)
        .contains('genres', userGenres) // Postgres array operator
        .limit(20);

    if (movies.length == 0) {
      // fallback: return 20 movies with images if genres are not set
      final fallback = await _client
          .from('movies')
          .select()
          .not('primary_image_url', 'is', null)
          .limit(20);
      return fallback;
    }

    return movies;
  }
}
