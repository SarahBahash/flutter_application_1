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
        backgroundColor: const Color.fromARGB(255, 73, 138, 212),
        elevation: 0, // Flat app bar for modern look
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Section
                Image.asset(
                  'assets/lounge_logo.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),

                // Title and Subtitle
                const Text(
                  'King Abdulaziz Airport Lounges',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Select a lounge to access premium services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Lounge Buttons
                _buildLoungeCard(
                  context,
                  title: 'AL Fursan Lounge',
                  description: 'Premium comfort and services.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Lounge1Page()),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildLoungeCard(
                  context,
                  title: 'PLAZA Premium Lounge',
                  description: 'Relax and rejuvenate in style.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Lounge2Page()),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildLoungeCard(
                  context,
                  title: 'Welcome Lounge',
                  description: 'Exceptional hospitality awaits.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Lounge3Page()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Lounge Card Builder
  Widget _buildLoungeCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        shadowColor: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.local_airport, color: Colors.blue[800], size: 40),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
