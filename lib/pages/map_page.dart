import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: nil,
        title: const Text('Map'),
      ),
      body: const Center(
        child: Text('Map Page'),
      ),
    );
  }
}
