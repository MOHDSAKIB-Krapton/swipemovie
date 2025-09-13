class Movie {
  final String title;
  final String poster;
  final String description;
  final String director;
  final String releaseDate;
  final List<String> genres;
  bool isFavorite = false;

  Movie({
    required this.title,
    required this.poster,
    required this.description,
    this.director = '',
    this.releaseDate = '',
    this.genres = const [],
    this.isFavorite = false,
  });
}
