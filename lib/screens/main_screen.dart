import 'package:flutter/material.dart';
import 'package:signlingo_1/screens/learn_screen.dart';
import 'package:signlingo_1/screens/settings_screen.dart';
import 'package:signlingo_1/screens/translate_screen.dart';
import 'package:signlingo_1/utils/app_themes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Iniciar en la sección de Traducir
  
  final List<Widget> _screens = [
    const LearnScreen(),
    const TranslateScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.school_outlined,
                color: _selectedIndex == 0 ? AppColors.accentColor : AppColors.lightGrey,
              ),
              label: 'Aprender',
              activeIcon: const Icon(Icons.school, color: AppColors.accentColor),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? AppColors.accentColor : AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.translate,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              label: 'Traducir',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                color: _selectedIndex == 2 ? AppColors.accentColor : AppColors.lightGrey,
              ),
              label: 'Configuración',
              activeIcon: const Icon(Icons.settings, color: AppColors.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}