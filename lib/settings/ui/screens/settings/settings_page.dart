import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingsPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
