import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swipemovie/screens/profile.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Movie> _stack = List.from(movies);
  final int cardsToShow = 5;
  int _frontIndex = 0;

  // live swipe direction tracking
  final ValueNotifier<CardSwiperDirection?> _activeDir =
      ValueNotifier<CardSwiperDirection?>(null);
  final ValueNotifier<double> _activeStrength = ValueNotifier<double>(0.0);

  void _toggleFavorite(Movie movie) {
    setState(() => movie.isFavorite = !movie.isFavorite);
  }

  @override
  void dispose() {
    _activeDir.dispose();
    _activeStrength.dispose();
    super.dispose();
  }

  // figure out drag direction based on percent thresholds
  CardSwiperDirection? _deriveDir(double px, double py, {double dead = 0.02}) {
    final ax = px.abs(), ay = py.abs();
    if (ax < dead && ay < dead) return null;
    if (ax > ay) {
      return px > 0 ? CardSwiperDirection.right : CardSwiperDirection.left;
    }
    return py > 0 ? CardSwiperDirection.bottom : CardSwiperDirection.top;
  }

  Widget _reactiveGlow({
    required CardSwiperDirection myDir,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? width, // use only when not giving left+right
    double? height, // use only when not giving top+bottom
    required Alignment begin,
    required Alignment end,
    required List<Color> colors,
  }) {
    return ValueListenableBuilder<CardSwiperDirection?>(
      valueListenable: _activeDir,
      builder: (context, dir, _) {
        return ValueListenableBuilder<double>(
          valueListenable: _activeStrength,
          builder: (context, k, __) {
            final visible = dir == myDir;
            return Positioned(
              left: left,
              right: right,
              top: top,
              bottom: bottom,
              width: width,
              height: height,
              child: AnimatedOpacity(
                opacity: visible ? k : 0.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
                child: IgnorePointer(
                  ignoring: true,
                  child: _BlurEdge(
                    width:
                        width ??
                        (right != null && left != null
                            ? double.infinity
                            : width ?? 0),
                    height:
                        height ??
                        (top != null && bottom != null
                            ? double.infinity
                            : height ?? 0),
                    colors: colors,
                    beginDirection: begin,
                    endDirection: end,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.8;
    final cardHeight = size.height * 0.55;
    const extra = 150.0; // for soft overflow of glow

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          // optional if you want rounded corners for the frosted area
          borderRadius: BorderRadius.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ), // frosted blur strength
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(
                0.25,
              ), // translucent dark tint
              elevation: 0,
              automaticallyImplyLeading: false, // hide default back button
              titleSpacing: 0, // remove default padding
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Left: App logo ---
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Image.asset('assets/images/logo.jpg', height: 40),
                  ),

                  // --- Right: action icons ---
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8), // small right padding
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // bottom glow
          _reactiveGlow(
            myDir: CardSwiperDirection.bottom,
            left: 0,
            right: 0,
            bottom: -extra,
            height: size.height * 0.1 + extra * 2,
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: const [Colors.orangeAccent],
          ),

          // left glow – top/bottom given, height omitted
          _reactiveGlow(
            myDir: CardSwiperDirection.left,
            left: -extra,
            top: -extra,
            bottom: -extra,
            width: size.width * 0.1 + extra * 2,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [Colors.redAccent],
          ),

          // right glow – top/bottom given, height omitted
          _reactiveGlow(
            myDir: CardSwiperDirection.right,
            right: -extra,
            top: -extra,
            bottom: -extra,
            width: size.width * 0.1 + extra * 2,
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: const [Colors.greenAccent],
          ),

          // top glow – left/right given, width omitted
          _reactiveGlow(
            myDir: CardSwiperDirection.top,
            left: 0,
            right: 0,
            top: -extra,
            height: size.height * 0.1 + extra * 2,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Colors.cyanAccent],
          ),

          SafeArea(
            child: Center(
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: CardSwiper(
                  scale: 0.93,
                  padding: const EdgeInsets.all(18),
                  backCardOffset: const Offset(0, 18),
                  duration: const Duration(milliseconds: 400),
                  numberOfCardsDisplayed: cardsToShow,
                  cardsCount: _stack.length,
                  cardBuilder: (context, index, percentX, percentY) {
                    // only top card updates direction
                    if (index == _frontIndex) {
                      final dir = _deriveDir(
                        (percentX as num).toDouble(),
                        (percentY as num).toDouble(),
                      );
                      final strength = max(
                        (percentX as num).abs().toDouble(),
                        (percentY as num).abs().toDouble(),
                      ).clamp(0.0, 1.0);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _activeDir.value = dir;
                        _activeStrength.value = strength;
                      });
                    }
                    final movie = _stack[index];
                    return Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.hardEdge,
                      child: MovieCard(
                        movie: movie,
                        onToggleFavorite: _toggleFavorite,
                      ),
                    );
                  },

                  onSwipe: (previousIndex, currentIndex, direction) {
                    _frontIndex = currentIndex as int;
                    // reset after swipe completes
                    _activeStrength.value = 0.0;
                    _activeDir.value = null;
                    setState(() {
                      final nextMovie = movies[Random().nextInt(movies.length)];
                      _stack.add(nextMovie);
                    });
                    return true;
                  },
                  onUndo: (previousIndex, currentIndex, direction) {
                    setState(() {
                      if (_stack.length > movies.length) _stack.removeLast();
                    });
                    return true;
                  },
                  isLoop: false,
                  allowedSwipeDirection: const AllowedSwipeDirection.all(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurEdge extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final Alignment beginDirection;
  final Alignment endDirection;

  const _BlurEdge({
    required this.width,
    required this.height,
    required this.colors,
    this.beginDirection = Alignment.topCenter,
    this.endDirection = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: beginDirection,
              end: endDirection,
              colors: [colors.first.withOpacity(0.8), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}
