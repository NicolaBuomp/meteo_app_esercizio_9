import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final String? buttonText;
  final VoidCallback? onTap;

  const TopBar({
    super.key,
    required this.title,
    this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Puoi personalizzarlo in base al tema
          ),
        ),
        if (buttonText != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              buttonText!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white70, // Personalizzabile
              ),
            ),
          ),
      ],
    );
  }
}
