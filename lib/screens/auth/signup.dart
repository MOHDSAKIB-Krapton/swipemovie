import 'package:flutter/material.dart';
import '../../provider/auth_provider.dart';
import './login.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signup() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authProvider.signup(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      // After a successful signup, the user is NOT logged in.
      // Show a success message and navigate to a new screen or the login screen.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Account created! Please check your email to confirm your account.",
          ),
          duration: Duration(seconds: 4),
        ),
      );

      // Navigate to the login screen so the user can log in after verification.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    emailController.addListener(_onFormChanged);
    passwordController.addListener(_onFormChanged);
    confirmPasswordController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {}); // triggers rebuild so conditions re-evaluate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1, // 👈 adjust to control visibility
              child: Image.asset(
                "assets/images/onboarding/slide_3.jpeg", // replace with your image path
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Color(0x80E50914),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Create Free Account",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),
                  _buildSignupForm(),
                  _Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFFE50914),
          decoration: _inputDecoration("Email"),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          cursorColor: const Color(0xFFE50914),
          decoration: _inputDecoration("Password"),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          cursorColor: const Color(0xFFE50914),
          decoration: _inputDecoration("Confirm Password"),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFFE50914)),
            ),
            onPressed:
                _isLoading ||
                    emailController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty ||
                    confirmPasswordController.text.trim().isEmpty
                ? null
                : _signup,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.redAccent,
                    ),
                  )
                : const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.white), // normal white text
              ),
              TextSpan(
                text: "Login",
                style: TextStyle(
                  color: Colors.redAccent,
                  decoration: TextDecoration.underline,
                ), // red for "Login"
              ),
            ],
          ),
        ),
      ),
    );
  }
}
