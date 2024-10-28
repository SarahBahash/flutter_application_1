import 'package:flutter/material.dart';
import 'lounge1_page.dart'; // Import pages for each lounge
import 'lounge2_page.dart';
import 'lounge3_page.dart';

class LoungeSelectionPage extends StatelessWidget {
  const LoungeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('King Airport Lounge'),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/lounge_logo.png',
                height: 250), // Ensure this image exists
            const SizedBox(height: 20),
            const Text(
              'Choose a Lounge',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Lounge1Page()), // Ensure Lounge1Page exists
                );
              },
              child: const Text('AL Fursan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Lounge2Page()), // Ensure Lounge2Page exists
                );
              },
              child: const Text('PLAZA premium'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Lounge3Page()), // Ensure Lounge3Page exists
                );
              },
              child: const Text('Wellcome'),
            ),
          ],
        ),
      ),
    );
  }
}
