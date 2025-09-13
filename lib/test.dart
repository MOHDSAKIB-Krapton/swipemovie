import 'dart:math';
import 'package:flutter/material.dart';
import 'package:swipemovie/data/movie_data.dart';
import 'package:swipemovie/models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_StackMovie> _stack = [];
  final int cardsToShow = 15;

  @override
  void initState() {
    super.initState();
    double angle = 0.2;
    for (int i = 0; i < cardsToShow; i++) {
      _stack.add(
        _StackMovie(
          movie: movies[i],
          id: UniqueKey(),
          angle: i == 0 ? 0 : (i.isEven ? angle : -angle),
        ),
      );
    }
  }

  void _toggleFavorite(Movie movie) {
    setState(() {
      movie.isFavorite = !movie.isFavorite;
    });
  }

  void _removeTopCard() {
    if (_stack.isEmpty) return;
    setState(() {
      _stack.removeAt(0);

      // pick next source movie (you may cycle or fetch)
      final nextMovie = movies[Random().nextInt(movies.length)];
      final lastAngle = _stack.isNotEmpty ? _stack.last.angle : 0.2;
      final nextAngle = lastAngle > 0 ? -0.2 : 0.2;

      // Add card with "entering" flag
      _stack.add(
        _StackMovie(
          movie: nextMovie,
          id: UniqueKey(),
          angle: nextAngle,
          isEntering: true,
        ),
      );
    });

    // trigger animation after a frame
    Future.delayed(Duration(milliseconds: 50), () {
      if (!mounted) return;
      setState(() {
        _stack.last.isEntering = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Recommender')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 500,
          child: Stack(
            children: _stack
                .asMap()
                .entries
                .map((entry) {
                  final i = entry.key;
                  final stackMovie = entry.value;
                  final isTop = i == 0;

                  return KeyedSubtree(
                    key: stackMovie.id,
                    child: AnimatedSlide(
                      offset: stackMovie.isEntering
                          ? const Offset(0, 1)
                          : Offset.zero,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        opacity: stackMovie.isEntering ? 0 : 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: Transform.translate(
                          offset: Offset(0, i * 20),
                          child: AnimatedRotation(
                            turns: isTop ? 0 : stackMovie.angle / (2 * pi),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            child: MovieCard(
                              movie: stackMovie.movie,
                              onToggleFavorite: _toggleFavorite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .toList()
                .reversed
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _removeTopCard,
        child: const Icon(Icons.remove),
      ),
    );
  }
}

class _StackMovie {
  final Movie movie;
  final Key id;
  final double angle;
  bool isEntering;
  _StackMovie({
    required this.movie,
    required this.id,
    required this.angle,
    this.isEntering = false,
  });
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function(Movie) onToggleFavorite;
  const MovieCard({
    super.key,
    required this.movie,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
