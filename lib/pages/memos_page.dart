import 'package:flutter/material.dart';

class MemosPage extends StatelessWidget {
  const MemosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
      ),
      body: const Center(
        child: Text('Welcome to Moe Memos!'),
      ),
    );
  }
}