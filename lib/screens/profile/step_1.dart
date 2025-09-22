import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipemovie/provider/auth_provider.dart';
import 'package:swipemovie/screens/profile/step_2.dart';
import 'package:swipemovie/services/profile.services.dart';
import 'package:swipemovie/widgets/common/selectable_grid.dart';

class SetupStep1 extends StatefulWidget {
  const SetupStep1({super.key});

  @override
  State<SetupStep1> createState() => _SetupStep1State();
}

class _SetupStep1State extends State<SetupStep1> {
  final ProfileService _profileService = ProfileService();

  final List<Map<String, String>> genres = const [
    {'label': 'Hollywood', 'imageUrl': 'assets/images/genres/hollywood.jpg'},
    {'label': 'Bollywood', 'imageUrl': 'assets/images/genres/bollywood.jpg'},
    {'label': 'Tollywood', 'imageUrl': 'assets/images/genres/tollywood.jpg'},
    {'label': 'Anime', 'imageUrl': 'assets/images/genres/anime.jpg'},
    {
      'label': 'Independent',
      'imageUrl': 'assets/images/genres/independent.jpg',
    },
    {
      'label': 'European Cinema',
      'imageUrl': 'assets/images/genres/europian_cinema.jpg',
    },
    {'label': 'Horror', 'imageUrl': 'assets/images/genres/horror.jpg'},
    {'label': 'Thriller', 'imageUrl': 'assets/images/genres/thriller.jpg'},
    {'label': 'Comedy', 'imageUrl': 'assets/images/genres/comedy.jpg'},
    {'label': 'Romance', 'imageUrl': 'assets/images/genres/romance.jpg'},
    {'label': 'Action', 'imageUrl': 'assets/images/genres/action.jpg'},
    {'label': 'Drama', 'imageUrl': 'assets/images/genres/drama.jpg'},
    {'label': 'Sci-Fi', 'imageUrl': 'assets/images/genres/sci_fi.jpg'},
    {'label': 'Fantasy', 'imageUrl': 'assets/images/genres/fantasy.jpg'},
    {'label': 'Documentary', 'imageUrl': 'assets/images/genres/documentry.jpg'},
    {'label': 'Animation', 'imageUrl': 'assets/images/genres/animation.jpg'},
    {'label': 'Musical', 'imageUrl': 'assets/images/genres/musical.jpg'},
    {'label': 'Crime', 'imageUrl': 'assets/images/genres/crime.jpg'},
    {'label': 'Mystery', 'imageUrl': 'assets/images/genres/mystry.jpg'},
  ];

  final Set<String> selectedGenres = {};
  bool isLoading = false;

  void _handleGenreTap(String label, bool selected) {
    setState(() {
      selected ? selectedGenres.remove(label) : selectedGenres.add(label);
    });
  }

  Future<void> _handleNext() async {
    if (selectedGenres.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 5 genres')),
      );
      return;
    }

    // Save genres to user profile
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    print('Debug: User ID: $userId');
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await _profileService.saveGenres(userId, selectedGenres.toList());
      // Navigate to Step 2
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SetupStep2()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save interests $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SelectableGrid(
                  title: 'Select at least 5 Genres you like',
                  items: genres,
                  selectedItems: selectedGenres,
                  onItemTap: _handleGenreTap,
                  onNext: _handleNext,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
