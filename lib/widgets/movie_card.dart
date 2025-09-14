import 'package:flutter/material.dart';
import 'package:swipemovie/screens/movie_detail.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
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
                  movie.primaryImageUrl!, // Use the new data field
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
              if (movie.aggregateRating != null)
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
                        // Use the new aggregateRating field
                        Text(
                          movie.aggregateRating.toString(),
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
