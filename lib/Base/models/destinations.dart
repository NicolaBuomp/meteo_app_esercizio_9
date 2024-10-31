import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Weather', icon: Icons.home_outlined),
  Destination(label: 'Settings', icon: Icons.settings_outlined),
];
