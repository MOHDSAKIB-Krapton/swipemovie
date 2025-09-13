import 'package:flutter/material.dart';
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
      onTap: () => _openDetailSheet(context), // 👈 tap triggers sheet
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.poster,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Text('Image failed')),
              ),
            ),
            IconButton(
              icon: Icon(
                movie.isFavorite ? Icons.star : Icons.star_border_outlined,
                color: movie.isFavorite ? Colors.yellow[700] : Colors.white,
                size: 36,
              ),
              onPressed: () => onToggleFavorite(movie),
            ),
          ],
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
      height: size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Hero(
            tag: 'poster-${movie.title}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                movie.poster,
                height: size.height * 0.35,
                width: size.width * 0.8,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (movie.genres.isNotEmpty)
            Text(
              movie.genres.join(', '),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          const SizedBox(height: 12),
          if (movie.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                movie.description,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Watch Now', style: TextStyle(fontSize: 18)),
              onPressed: () {
                // TODO: implement play action
              },
            ),
          ),
        ],
      ),
    );
  }
}
