import 'package:flutter/material.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function(Movie) onToggleFavorite;
  const MovieCard({
    super.key,
    required this.movie,
    required this.onToggleFavorite,
  });

  void _openDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _MovieDetailSheet(movie: movie), // 👈 inner sheet widget below
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetailSheet(context),
      child: Hero(
        tag: 'poster-${movie.title}',
        child: ClipRRect(
          child: Stack(
            children: [
              // Poster
              Positioned.fill(
                child: Image.network(
                  movie.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),

              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Rating badge (top-left)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Favorite button (top-right)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.star, color: Colors.yellow[700], size: 32),
                  onPressed: () => onToggleFavorite(movie),
                ),
              ),

              // Movie title (bottom overlay)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieDetailSheet extends StatelessWidget {
  final Movie movie;
  const _MovieDetailSheet({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.78,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          // --- Blurred backdrop background ---
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.network(
                movie.backdrop,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),

          // --- Foreground content ---
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // handle bar
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),

                // poster with Hero animation
                Hero(
                  tag: 'poster-${movie.title}',
                  child: ClipRRect(
                    child: Image.network(
                      movie.poster,
                      height: size.height * 0.32,
                      width: size.width * 0.55,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // title
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // release date + language
                Text(
                  "Released: ${movie.releaseDate} • Lang: ${movie.originalLanguage.toUpperCase()}",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 12),

                // rating + votes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      "${movie.rating.toStringAsFixed(1)} ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${movie.voteCount} votes)",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // genres
                if (movie.genreIds.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: movie.genreIds
                        .map(
                          (id) => Chip(
                            label: Text(
                              id.toString(), // replace with genre map if available
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.black,
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 16),

                // description
                if (movie.description.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        movie.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // watch button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: PrimaryButton(onTap: () => {}, label: 'Watch Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
