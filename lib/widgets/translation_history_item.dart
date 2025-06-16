import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signlingo_1/utils/app_themes.dart';

enum TranslationType {
  textToSign,
  signToText,
}

class TranslationHistoryItem {
  final String originalText;
  final TranslationType translationType;
  final DateTime timestamp;

  TranslationHistoryItem({
    required this.originalText,
    required this.translationType,
    required this.timestamp,
  });
}

class TranslationHistoryItemWidget extends StatelessWidget {
  final TranslationHistoryItem item;

  const TranslationHistoryItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_Hm();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.translationType == TranslationType.textToSign
                  ? Icons.gesture
                  : Icons.text_fields,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Aquí se mostrará la letra (ej. "A")
                  item.originalText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.translationType == TranslationType.textToSign
                      ? 'Texto a Señas'
                      : 'Señas a Texto',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(item.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.lightGrey),
            onSelected: (value) {
              // Implementar acciones: copiar, compartir, eliminar…
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 20),
                    SizedBox(width: 8),
                    Text('Copiar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text('Compartir'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 8),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
