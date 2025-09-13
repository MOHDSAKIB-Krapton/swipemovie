import 'package:flutter/material.dart';
import 'package:swipemovie/widgets/onboarding/slider.dart';
import '../provider/auth_provider.dart';
import '../screens/auth/login.dart';
// import '../screens/home.dart';
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
      return const LoginScreen();
    }

    return const OnBoarding();
  }
}
