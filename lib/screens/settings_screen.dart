import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  final Color background = const Color(0xFF0D1B2A);
  final Color cardColor = const Color(0xFF1B263B);
  final Color accentColor = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Text(
          'Configuración',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Cuenta'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Perfil',
            subtitle: 'Editar información personal',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Contraseña',
            subtitle: 'Cambiar contraseña',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Preferencias'),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: 'Español',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Soporte'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Sobre la app',
            subtitle: 'Versión 1.0.0',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            subtitle: 'Salir de tu cuenta',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: accentColor),
        title: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13))
            : null,
        trailing: trailing ??
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }
}
