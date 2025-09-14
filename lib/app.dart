import 'package:flutter/material.dart';
import 'package:swipemovie/screens/home.dart';
import 'package:swipemovie/widgets/onboarding/slider.dart';
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
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.user == null) {
      return const OnBoarding();
    }

    return const HomeScreen();
  }
}
