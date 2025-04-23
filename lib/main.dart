import 'package:flutter/material.dart';
import 'package:signlingo_1/screens/onboarding_screen.dart';
import 'package:signlingo_1/screens/auth/login_screen.dart';
import 'package:signlingo_1/utils/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignLingo',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // Using the themes from utils
      home: const OnboardingScreen(), // Falta hacer que cambie post login o post register
      // home: const LoginScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}
