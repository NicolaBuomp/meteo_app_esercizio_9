import 'package:flutter/material.dart';
import 'search_input.dart';

class SearchBarInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchBarInput({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: SearchInput(controller: controller),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSearch,
            child: const Text(
              'Cerca',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
