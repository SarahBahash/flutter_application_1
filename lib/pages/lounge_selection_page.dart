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
        backgroundColor: const Color(0xFF4A8AD4), // Updated to match theme
        elevation: 0, // Flat app bar for a modern look
        centerTitle: true, // Centered title
      ),
      body: Container(
        color: const Color(0xFFF5F7FA), // Light background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    fontSize: 26,
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
                const SizedBox(height: 70),

                // Lounge Buttons
                Expanded(
                  child: ListView(
                    children: [
                      _buildLoungeCard(
                        context,
                        title: 'AL Fursan Lounge',
                        description: 'Premium comfort and services.',
                        icon: Icons.airline_seat_flat,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Lounge1Page()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildLoungeCard(
                        context,
                        title: 'PLAZA Premium Lounge',
                        description: 'Relax and rejuvenate in style.',
                        icon: Icons.local_cafe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Lounge2Page()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildLoungeCard(
                        context,
                        title: 'Welcome Lounge',
                        description: 'Exceptional hospitality awaits.',
                        icon: Icons.hotel,
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
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4A8AD4), // Circle background
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
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
