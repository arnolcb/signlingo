import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  Color get primaryColor => const Color(0xFF1E88E5);
  Color get background => const Color(0xFF0D1B2A);
  Color get cardColor => const Color(0xFF1B263B);
  Color get accentColor => Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Text('Aprender',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildCategoriesSection(),
            const SizedBox(height: 24),
            _buildLessonsSection(),
            const SizedBox(height: 24),
            _buildDailyPracticeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'title': 'Alfabeto', 'icon': Icons.abc, 'lessons': 26},
      {'title': 'Números', 'icon': Icons.filter_9_plus, 'lessons': 10},
      {'title': 'Frases Básicas', 'icon': Icons.chat_bubble_outline, 'lessons': 15},
      {'title': 'Colores', 'icon': Icons.color_lens_outlined, 'lessons': 8},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categorías',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold, color: accentColor)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.5),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              title: category['title'] as String,
              icon: category['icon'] as IconData,
              lessons: category['lessons'] as int,
            );
          },
        )
      ],
    );
  }

  Widget _buildCategoryCard({required String title, required IconData icon, required int lessons}) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: accentColor),
              const SizedBox(height: 12),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              Text('$lessons lecciones',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsSection() {
    final lessons = [
      {
        'title': 'Saludos básicos',
        'description': 'Aprende a saludar y dar buenos días.',
        'progress': 0.8,
      },
      {
        'title': 'Presentaciones',
        'description': 'Cómo presentarte y preguntar nombres.',
        'progress': 0.6,
      },
      {
        'title': 'Números del 1-10',
        'description': 'Aprende signos para números básicos.',
        'progress': 0.4,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lecciones recientes',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold, color: accentColor)),
        const SizedBox(height: 16),
        ...lessons.map((lesson) => _buildLessonCard(
          title: lesson['title'] as String,
          description: lesson['description'] as String,
          progress: lesson['progress'] as double,
        ))
      ],
    );
  }

  Widget _buildLessonCard({required String title, required String description, required double progress}) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            const SizedBox(height: 4),
            Text(description, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDailyPracticeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Práctica diaria',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold, color: accentColor)),
        const SizedBox(height: 16),
        Card(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 40, color: accentColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ejercicio del día',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Reto diario para reforzar lo aprendido.',
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70))
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
