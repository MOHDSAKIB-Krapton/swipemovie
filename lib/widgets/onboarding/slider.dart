import 'package:flutter/cupertino.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import "package:flutter/material.dart";
import 'package:swipemovie/screens/auth/signup.dart';

const List<Map<String, String>> onboardingPages = [
  {
    'image': 'assets/images/onboarding/slide_1.jpeg',
    'title': 'Swipe. Discover. Enjoy.',
    'description':
        'Explore endless movies with a simple swipe. Your next favorite film is just one gesture away.',
  },
  {
    'image': 'assets/images/onboarding/slide_3.jpeg',
    'title': 'AI-Powered Suggestions',
    'description':
        'Our smart algorithm learns your taste with every swipe, giving you personalized recommendations that get better over time.',
  },
  {
    'image': 'assets/images/onboarding/slide_2.jpeg',
    'title': 'Your Movie Companion',
    'description':
        'Build a watchlist, track what you love, and stay updated with fresh picks tailored just for you.',
  },
];

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacerHeight = screenHeight * 0.55;

    return CupertinoApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.transparent,
        finishButtonText: 'Register',
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Color(0xFFE50914),
          shape: BeveledRectangleBorder(),
          elevation: 5,
        ),
        onFinish: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
          );
        },
        controllerColor: Colors.black,
        background: [
          Image.asset("${onboardingPages[0]['image']}"),
          Image.asset("${onboardingPages[1]['image']}"),
          Image.asset("${onboardingPages[2]['image']}"),
        ],
        totalPage: onboardingPages.length,
        speed: 0.8,
        pageBodies: List.generate(
          onboardingPages.length,
          (index) => Stack(
            children: [
              // Gradient overlay
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
              // Text content
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: spacerHeight * 0.1),
                    Text(
                      onboardingPages[index]['title']!,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      onboardingPages[index]['description']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
