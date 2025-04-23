import 'package:flutter/material.dart';
import 'package:signlingo_1/utils/app_themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Cuenta'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Perfil',
            subtitle: 'Editar información personal',
            onTap: () {
              // Navegar a pantalla de perfil
            },
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Contraseña',
            subtitle: 'Cambiar contraseña',
            onTap: () {
              // Navegar a pantalla de cambio de contraseña
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Preferencias'),
          /*
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Modo oscuro',
            subtitle: 'Activar o desactivar tema oscuro',
            trailing: Switch(
              value: false, // Aquí podrías usar un provider o estado global
              onChanged: (value) {
                // Cambiar tema
              },
            ),
          ),
          */
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: 'Español',
            onTap: () {
              // Mostrar selector de idiomas
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Soporte'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Sobre la app',
            subtitle: 'Versión 1.0.0',
            onTap: () {
              // Mostrar detalles de la app
            },
          ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            subtitle: 'Salir de tu cuenta',
            onTap: () {
              // Implementar cierre de sesión
            },
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accentColor),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
