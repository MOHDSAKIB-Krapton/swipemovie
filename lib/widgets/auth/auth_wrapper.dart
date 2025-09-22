import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipemovie/screens/home.dart';
import 'package:swipemovie/screens/profile/step_1.dart';
import 'package:swipemovie/screens/profile/step_2.dart';
import 'package:swipemovie/services/profile.services.dart';
import 'package:swipemovie/widgets/onboarding/slider.dart';
import '../../provider/auth_provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final Stream<AuthState> _authStateChanges;
  final ProfileService _profileService = ProfileService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authStateChanges = authProvider.authStateChanges;
  }

  @override
  Widget build(BuildContext context) {
    // We use a StreamBuilder to handle the state and automatically rebuild
    return StreamBuilder<AuthState>(
      stream: _authStateChanges,
      builder: (context, snapshot) {
        // You can show a loading indicator while waiting for the first snapshot
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        final user = snapshot.data?.session?.user;

        if (user == null) return const OnBoarding();

        return FutureBuilder<Map<String, dynamic>?>(
          future: _profileService.fetchProfile(user.id),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFFE50914)),
                ),
              );
            }
            if (snap.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    'Error loading profile: ${snap.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
            final profile = snap.data;

            // Profile does not exist
            if (profile == null) {
              return const SetupStep1(); // first setup screen (select genres)
            }

            // Profile exists but genre list is empty
            if ((profile['genres'] as List?)?.isEmpty ?? true) {
              return const SetupStep1();
            }

            // Profile exists, genres are set, but interests are empty
            if ((profile['interests'] as List?)?.isEmpty ?? true) {
              return const SetupStep2();
            }

            // Everything is set, go to home screen
            return const HomeScreen();
          },
        );
      },
    );
  }
}
