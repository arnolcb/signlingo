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
  int _selectedIndex = 1; // Traducir por defecto

  final List<Widget> _screens = const [
    LearnScreen(),
    TranslateScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? AppColors.accentColor : Colors.grey,
      ),
      activeIcon: Icon(
        activeIcon,
        color: AppColors.accentColor,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fondo oscuro
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: AppColors.accentColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildBottomNavigationBarItem(
              icon: Icons.school_outlined,
              activeIcon: Icons.school,
              label: 'Aprender',
              index: 0,
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1
                      ? AppColors.accentColor
                      : Colors.grey.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.translate,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              label: 'Traducir',
            ),
            _buildBottomNavigationBarItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: 'Configuración',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }
}
