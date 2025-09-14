import 'package:flutter/material.dart';
import 'package:swipemovie/screens/auth/signup.dart';
import 'package:swipemovie/screens/home.dart';
import 'package:swipemovie/widgets/common/input_field.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';
import '../../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isFormValid =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  Future<void> _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await authProvider.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

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

    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
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
              opacity: 0.1,
              child: Image.asset(
                "assets/images/onboarding/slide_3.jpeg",
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
                    "Login To Your Account",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),
                  _buildLoginForm(),
                  _Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        InputField(
          controller: emailController,
          hintText: "Email",
          inputType: InputType.email,
        ),

        const SizedBox(height: 16),

        InputField(
          controller: passwordController,
          hintText: "Password",
          inputType: InputType.password,
        ),

        const SizedBox(height: 24),

        PrimaryButton(
          label: 'Login',
          onTap: _login,
          isLoading: _isLoading,
          enabled: isFormValid,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
          );
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: "Dont't have an account? ",
                style: TextStyle(color: Colors.white), // normal white text
              ),
              TextSpan(
                text: "SignUp",
                style: TextStyle(
                  color: Color(0xFFE50914),
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
