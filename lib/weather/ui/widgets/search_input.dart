import 'package:flutter/material.dart';

class CustomSearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final VoidCallback onLeadingIconTap;
  final VoidCallback onTrailingIconTap;

  const CustomSearchInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.onLeadingIconTap,
    required this.onTrailingIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Arrotondamento dei bordi
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLeadingIconTap,
            child: Icon(leadingIcon, color: const Color(0xFF767676)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xFF767676)),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Color(0xFF767676)),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTrailingIconTap,
            child: Icon(trailingIcon, color: const Color(0xFF767676)),
          ),
        ],
      ),
    );
  }
}
