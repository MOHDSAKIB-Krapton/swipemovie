import 'package:flutter/material.dart';
import 'package:swipemovie/data/movie_data.dart';
import 'package:swipemovie/models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Movie> _movies = movies;
  int _currentIndex = 0;

  // Animation controllers
  late AnimationController _positionController;
  late AnimationController _fadeController;

  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Card state
  double _dragX = 0;
  double _dragY = 0;
  bool _isDragging = false;

  // Constants for better UX
  static const double _swipeThreshold = 80.0;
  static const double _rotationFactor = 0.1;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _snapBackDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _positionController = AnimationController(
      vsync: this,
      duration: _snapBackDuration,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(2.0, 0)).animate(
          CurvedAnimation(parent: _positionController, curve: Curves.easeOut),
        );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.3).animate(
      CurvedAnimation(parent: _positionController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _positionController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
    _positionController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.4;

    setState(() {
      _dragX = (_dragX + details.delta.dx).clamp(-maxDrag, maxDrag);
      _dragY = (_dragY + details.delta.dy).clamp(-200.0, 200.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    setState(() {
      _isDragging = false;
    });

    final velocity = details.velocity.pixelsPerSecond;
    final horizontalVelocity = velocity.dx.abs();
    final verticalVelocity = velocity.dy.abs();

    // Determine swipe direction and action
    String? action;
    bool shouldSwipe = false;

    if (horizontalVelocity > 500 || _dragX.abs() > _swipeThreshold) {
      // Horizontal swipe
      if (_dragX > 0 || velocity.dx > 0) {
        action = 'Watched & Liked';
        shouldSwipe = true;
      } else if (_dragX < 0 || velocity.dx < 0) {
        action = 'Watched & Disliked';
        shouldSwipe = true;
      }
    } else if (verticalVelocity > 500 || _dragY.abs() > _swipeThreshold) {
      // Vertical swipe
      if (_dragY < 0 || velocity.dy < 0) {
        action = 'Unwatched & Disliked';
        shouldSwipe = true;
      } else if (_dragY > 0 || velocity.dy > 0) {
        action = 'Unwatched & Liked';
        shouldSwipe = true;
      }
    }

    if (shouldSwipe && action != null) {
      _swipeCard(action, _dragX > 0 || velocity.dx > 0);
    } else {
      _snapBack();
    }
  }

  void _moveToNextMovie() {
    // Reset all transforms and controllers before showing next card
    _positionController.reset();
    _fadeController.reset();
    setState(() {
      _currentIndex = (_currentIndex + 1) % _movies.length;
      _dragX = 0;
      _dragY = 0;
      _isDragging = false;
    });
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_positionController);
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_positionController);
    _fadeController.reverse();
  }

  void _swipeCard(String action, bool swipeRight) async {
    _showActionFeedback(action);
    _slideAnimation =
        Tween<Offset>(
          begin: Offset(
            _dragX / MediaQuery.of(context).size.width,
            _dragY / 500,
          ),
          end: Offset(swipeRight ? 2.0 : -2.0, _dragY / 500),
        ).animate(
          CurvedAnimation(
            parent: _positionController,
            curve: Curves.fastOutSlowIn,
          ),
        );
    _rotationAnimation =
        Tween<double>(
          begin: _dragX * _rotationFactor / 100,
          end: swipeRight ? 0.3 : -0.3,
        ).animate(
          CurvedAnimation(
            parent: _positionController,
            curve: Curves.fastOutSlowIn,
          ),
        );
    await Future.wait([
      _fadeController.forward(),
      _positionController.forward(),
    ]);
    _moveToNextMovie();
  }

  void _snapBack() {
    _slideAnimation =
        Tween<Offset>(
          begin: Offset(
            _dragX / MediaQuery.of(context).size.width,
            _dragY / 500,
          ),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _positionController,
            curve: Curves.elasticOut,
          ),
        );

    _rotationAnimation =
        Tween<double>(begin: _dragX * _rotationFactor / 100, end: 0).animate(
          CurvedAnimation(
            parent: _positionController,
            curve: Curves.elasticOut,
          ),
        );

    _positionController.forward().then((_) {
      _resetCardState();
    });
  }

  void _resetCardState() {
    setState(() {
      _dragX = 0;
      _dragY = 0;
      _isDragging = false;
    });
    _positionController.reset();
  }

  void _showActionFeedback(String action) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_movies[_currentIndex].title} - $action'),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _movies[_currentIndex].isFavorite = !_movies[_currentIndex].isFavorite;
    });
  }

  void _showDetailsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'movie-poster-${_movies[_currentIndex].title}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    _movies[_currentIndex].poster,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _movies[_currentIndex].title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _movies[_currentIndex].description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwipeOverlay() {
    if (!_isDragging) return const SizedBox.shrink();

    final opacity = (_dragX.abs() / _swipeThreshold).clamp(0.0, 1.0);
    final isRight = _dragX > 0;
    final isVertical = _dragY.abs() > _dragX.abs();

    Color overlayColor;
    String text;
    IconData icon;

    if (isVertical) {
      if (_dragY < 0) {
        overlayColor = Colors.red;
        text = "SKIP";
        icon = Icons.close;
      } else {
        overlayColor = Colors.blue;
        text = "SAVE";
        icon = Icons.bookmark;
      }
    } else {
      if (isRight) {
        overlayColor = Colors.green;
        text = "LIKE";
        icon = Icons.favorite;
      } else {
        overlayColor = Colors.red;
        text = "NOPE";
        icon = Icons.close;
      }
    }

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: overlayColor.withOpacity(0.2 * opacity),
          border: Border.all(
            color: overlayColor.withOpacity(opacity),
            width: 3,
          ),
        ),
        child: Center(
          child: Opacity(
            opacity: opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: overlayColor),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: overlayColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = _movies[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Recommender'), centerTitle: true),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_positionController, _fadeController]),
          builder: (context, child) {
            final offset = _isDragging
                ? Offset(
                    _dragX / MediaQuery.of(context).size.width,
                    _dragY / 500,
                  )
                : _slideAnimation.value;

            final rotation = _isDragging
                ? _dragX * _rotationFactor / 100
                : _rotationAnimation.value;

            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: AlwaysStoppedAnimation(offset),
                  child: Transform.rotate(
                    angle: rotation,
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      onTap: _showDetailsBottomSheet,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: SizedBox(
                          width: 300,
                          height: 500,
                          child: Stack(
                            children: [
                              Hero(
                                tag: 'movie-poster-${movie.title}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    movie.poster,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.error, size: 64),
                                            Text('Image failed to load'),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              _buildSwipeOverlay(),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      movie.isFavorite
                                          ? Icons.star
                                          : Icons.star_border_outlined,
                                      color: movie.isFavorite
                                          ? Colors.yellow[700]
                                          : Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: _toggleFavorite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
