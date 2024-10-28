import 'package:flutter/material.dart';

class Lounge2Page extends StatelessWidget {
  const Lounge2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lounge 2'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Lounge 1!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/lounge1_image.png',
                height: 200), // Ensure this image exists
            const SizedBox(height: 20),
            const Text(
              'Enjoy your stay!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
