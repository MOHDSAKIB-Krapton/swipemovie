// auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipemovie/screens/auth/login.dart';
import 'package:swipemovie/screens/home.dart';
import '../../provider/auth_provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final Stream<AuthState> _authStateChanges;

  @override
  void initState() {
    super.initState();
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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data?.session?.user;

        if (user == null) {
          // User is not logged in, show the login screen
          return const LoginScreen();
        } else {
          // User is logged in, show the home screen
          return const HomeScreen();
        }
      },
    );
  }
}
