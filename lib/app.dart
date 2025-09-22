import 'package:flutter/material.dart';
import 'package:swipemovie/screens/auth/login.dart';
import 'package:swipemovie/screens/auth/signup.dart';
import 'package:swipemovie/screens/home.dart';
import 'package:swipemovie/screens/profile.dart';
import 'package:swipemovie/widgets/auth/auth_wrapper.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),

        // Register routes here
        routes: {
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignupScreen(),

          '/home': (_) => const HomeScreen(),
          '/profile': (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
