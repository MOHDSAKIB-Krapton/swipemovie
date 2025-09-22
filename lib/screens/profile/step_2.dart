import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipemovie/provider/auth_provider.dart';
import 'package:swipemovie/screens/home.dart';
import 'package:swipemovie/services/movies.services.dart';
import 'package:swipemovie/widgets/common/selectable_grid.dart';
import 'package:swipemovie/services/profile.services.dart';

class SetupStep2 extends StatefulWidget {
  const SetupStep2({super.key});

  @override
  State<SetupStep2> createState() => _SetupStep2State();
}

class _SetupStep2State extends State<SetupStep2> {
  final ProfileService _profileService = ProfileService();
  final Set<String> selectedInterests = {};

  List<Map<String, String>> movies = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final fetchedMovies = await MoviesService().fetchInitialMovies(userId);
    setState(() {
      movies = fetchedMovies.map((e) {
        return {
          'label': e['title'].toString(),
          'imageUrl': e['primary_image_url'].toString(),
        };
      }).toList();
    });
  }

  void _handleItemTap(String label, bool selected) {
    setState(() {
      selected ? selectedInterests.remove(label) : selectedInterests.add(label);
    });
  }

  Future<void> _handleNext() async {
    if (selectedInterests.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 3 Movies')),
      );
      return;
    }

    // Save interests to user profile
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;

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
      await _profileService.saveInterests(userId, selectedInterests.toList());
      // Navigate to Home Screen, Profile Completed.
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
          child: movies.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SelectableGrid(
                  title: 'Select at least 3 movies you like',
                  items: movies,
                  selectedItems: selectedInterests,
                  onItemTap: _handleItemTap,
                  onNext: _handleNext,
                ),
        ),
      ),
    );
  }
}
