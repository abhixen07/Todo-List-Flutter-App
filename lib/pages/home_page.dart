import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 80,
          backgroundColor: Colors.green,
          child: Icon(
            Icons.check,
            size: 100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}