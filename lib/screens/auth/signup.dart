import 'package:flutter/material.dart';
import 'package:swipemovie/widgets/common/input_field.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';
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
  final nameController = TextEditingController();

  bool _isLoading = false;

  bool get isFormValid =>
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      nameController.text.isNotEmpty;

  Future<void> _signup() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await authProvider.signup(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
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

    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
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
        InputField(
          controller: nameController,
          hintText: "Full Name",
          inputType: InputType.name,
        ),

        const SizedBox(height: 16),

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
          label: 'Submit',
          onTap: _signup,
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
