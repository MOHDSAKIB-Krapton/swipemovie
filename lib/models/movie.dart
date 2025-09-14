class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final String description;
  final String releaseDate;
  final String poster;
  final String backdrop;
  final List<int> genreIds;
  final double popularity;
  final double rating;
  final int voteCount;
  final bool adult;
  final bool video;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalLanguage,
    required this.description,
    required this.releaseDate,
    required this.poster,
    required this.backdrop,
    required this.genreIds,
    required this.popularity,
    required this.rating,
    required this.voteCount,
    required this.adult,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      description: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      poster: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      backdrop: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}'
          : '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      rating: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
    );
  }
}
