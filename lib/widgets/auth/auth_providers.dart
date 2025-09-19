import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipemovie/screens/home.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';
import '../../provider/auth_provider.dart'; // Adjust path if needed

class AuthProviders extends StatefulWidget {
  final String title;

  const AuthProviders({super.key, this.title = 'Continue with Google'});

  @override
  State<AuthProviders> createState() => _AuthProvidersState();
}

class _AuthProvidersState extends State<AuthProviders> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> continueWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await authProvider.signInWithGoogle();

      if (!mounted) return;

      // optional: navigate to home if login succeeded
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Note: The OAuth flow may throw an exception if the user cancels
      // or if deep linking/setup is incorrect.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          label: 'Sign In with Google',
          onTap: continueWithGoogle,
          isLoading: _isLoading,
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
