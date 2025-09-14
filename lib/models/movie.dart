import 'dart:convert';

class Movie {
  final int idx;
  final String id;
  final String title;
  final String originalTitle;
  final String titleType;
  final int? releaseYear;
  final String? releaseDate;
  final int? runtimeSeconds;
  final String? aggregateRating;
  final int? voteCount;
  final List<String> genres;
  final String? plot;
  final PrimaryImage primaryImage;
  final List<Credit> directors;
  final List<Credit> writers;
  final List<Credit> casts;
  final bool isAdult;
  final String? certificate;
  final String? primaryImageUrl;
  final String? trailerUrl;
  final List<String> languages;
  final List<String> countries;
  final List<String> productionCompanies;

  Movie({
    required this.idx,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.titleType,
    required this.releaseYear,
    required this.releaseDate,
    required this.runtimeSeconds,
    required this.aggregateRating,
    required this.voteCount,
    required this.genres,
    required this.plot,
    required this.primaryImage,
    required this.directors,
    required this.writers,
    required this.casts,
    required this.isAdult,
    this.certificate,
    this.primaryImageUrl,
    this.trailerUrl,
    required this.languages,
    required this.countries,
    required this.productionCompanies,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      idx: map['idx'] as int,
      id: map['id'] as String,
      title: map['title'] as String,
      originalTitle: map['original_title'] as String,
      titleType: map['title_type'] as String,
      releaseYear: map['release_year'] as int?,
      releaseDate: map['release_date'] as String?,
      runtimeSeconds: map['runtime_seconds'] as int?,
      aggregateRating: map['aggregate_rating'] as String?,
      voteCount: map['vote_count'] as int?,
      genres: List<String>.from(map['genres']),
      plot: map['plot'] as String?,
      primaryImage: PrimaryImage.fromMap(jsonDecode(map['primary_image'])),
      directors: List<Credit>.from(
        jsonDecode(map['directors']).map((x) => Credit.fromMap(x)),
      ),
      writers: List<Credit>.from(
        jsonDecode(map['writers']).map((x) => Credit.fromMap(x)),
      ),
      casts: List<Credit>.from(
        jsonDecode(map['casts']).map((x) => Credit.fromMap(x)),
      ),
      isAdult: map['is_adult'] as bool,
      certificate: map['certificate'] as String?,
      primaryImageUrl: map['primary_image_url'] as String?,
      trailerUrl: map['trailer_url'] as String?,
      languages: List<String>.from(map['languages']),
      countries: List<String>.from(map['countries']),
      productionCompanies: List<String>.from(map['production_companies']),
    );
  }
}

class Credit {
  final String id;
  final String name;
  final String? image;
  final List<String>? characters;

  Credit({required this.id, required this.name, this.image, this.characters});

  factory Credit.fromMap(Map<String, dynamic> map) {
    return Credit(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String?,
      characters: map['characters'] == null
          ? null
          : List<String>.from(map['characters']),
    );
  }
}

class PrimaryImage {
  final String url;
  final int width;
  final int height;

  PrimaryImage({required this.url, required this.width, required this.height});

  factory PrimaryImage.fromMap(Map<String, dynamic> map) {
    return PrimaryImage(
      url: map['url'] as String,
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }
}
