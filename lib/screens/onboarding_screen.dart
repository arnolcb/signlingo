import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signlingo_1/screens/auth/login_screen.dart';
import 'package:signlingo_1/utils/app_themes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Bienvenido a SignLingo",
      description: "Tu traductor de lenguaje de señas en tiempo real",
      image: "assets/images/onboarding_1.png",
      backgroundColor: AppColors.primaryColor,
    ),
    OnboardingPage(
      title: "Traducción en Tiempo Real",
      description: "Convierte texto a lenguaje de señas y viceversa con nuestra avanzada tecnología de reconocimiento",
      image: "assets/images/onboarding_2.png",
      backgroundColor: AppColors.lightPrimaryColor,
    ),
    OnboardingPage(
      title: "Aprende Lenguaje de Señas",
      description: "Mejora tus habilidades con nuestras lecciones interactivas y ejercicios prácticos",
      image: "assets/images/onboarding_3.png",
      backgroundColor: AppColors.accentColor,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_onboarding', false);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDotIndicator(index),
                  ),
                ),
                const SizedBox(height: 40),
                _currentPage == _pages.length - 1
                    ? _buildGetStartedButton()
                    : _buildNextButton(),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: const Text('Saltar', style: TextStyle(color: AppColors.whiteColor)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      color: page.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            page.image,
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 50),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.whiteColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.whiteColor,
        foregroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildGetStartedButton() {
    return ElevatedButton(
      onPressed: _completeOnboarding,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.whiteColor,
        foregroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text('Comenzar', style: TextStyle(fontSize: 16)),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}