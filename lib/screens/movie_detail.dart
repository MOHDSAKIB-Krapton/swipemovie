import 'package:flutter/material.dart';
import 'package:swipemovie/widgets/common/person_list.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  String? getImdbVideoPageUrl(String? trailerUrl) {
    if (trailerUrl == null || trailerUrl.isEmpty) return null;

    // Match the 'vi' video ID pattern in the URL
    final regex = RegExp(r'/vi(\d+)/');
    final match = regex.firstMatch(trailerUrl);

    if (match != null && match.groupCount >= 1) {
      final videoId = 'vi${match.group(1)}';
      return 'https://www.imdb.com/video/$videoId/';
    }

    return null; // Return null if no match found
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isLoadingTrailer = false;

    Future<void> launchTrailer() async {
      final url = getImdbVideoPageUrl(widget.movie.trailerUrl);
      if (url == null) return;
      setState(() => isLoadingTrailer = true);
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        // handle error if needed
      } finally {
        setState(() => isLoadingTrailer = false);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // --- Hero AppBar with poster ---
          SliverAppBar(
            expandedHeight: size.height * 0.45,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'poster-${widget.movie.id}',
                    child: Image.network(
                      widget.movie.primaryImageUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ), // gradient overlay
                ],
              ),
              title: Text(
                widget.movie.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // --- Movie content ---
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height * 1, // 120% of screen
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Year
                    Text(
                      "${widget.movie.title} ${widget.movie.releaseYear != null ? '(${widget.movie.releaseYear})' : ''}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Release Date • Runtime • Language
                    Text(
                      [
                        widget.movie.releaseDate != null
                            ? "Released: ${widget.movie.releaseDate}"
                            : null,
                        widget.movie.runtimeSeconds != null
                            ? "Runtime: ${widget.movie.runtimeSeconds! ~/ 60} mins"
                            : null,
                        widget.movie.languages.isNotEmpty
                            ? "Lang: ${widget.movie.languages.join(", ")}"
                            : null,
                        widget.movie.countries.isNotEmpty
                            ? "Country: ${widget.movie.countries.join(", ")}"
                            : null,
                      ].whereType<String>().join(" • "),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Ratings
                    Row(
                      spacing: 6,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(
                          widget.movie.aggregateRating != null
                              ? "${widget.movie.aggregateRating}/10"
                              : "N/A",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.movie.voteCount != null
                              ? " (${widget.movie.voteCount} votes)"
                              : "N/A",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Genres
                    if (widget.movie.genres.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        children: widget.movie.genres
                            .map(
                              (g) => Chip(
                                label: Text(
                                  g,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.grey[850],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey[850]!),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    Text(
                      widget.movie.plot ??
                          "NO PLOT AVAILABLE FOR THIS MOVIE", // safe to use ! because we checked for null
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Directors
                    PersonList(
                      title: "Directors",
                      data: widget.movie.directors
                          .map((d) => {'name': d.name, 'image': d.image})
                          .toList(),
                    ),

                    // Writers
                    PersonList(
                      title: "Writers",
                      data: widget.movie.writers
                          .map((w) => {'name': w.name, 'image': w.image})
                          .toList(),
                    ),

                    // Casts
                    PersonList(
                      title: "Cast",
                      data: widget.movie.casts
                          .map((c) => {'name': c.name, 'image': c.image})
                          .toList(),
                    ),

                    // Production Companies
                    if (widget.movie.productionCompanies.isNotEmpty) ...[
                      const Text(
                        "Production",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.movie.productionCompanies.join(", "),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                    ],

                    PrimaryButton(
                      label: "Watch Trailer",
                      onTap: launchTrailer,
                      isLoading: isLoadingTrailer,
                      enabled: widget.movie.trailerUrl != null,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
