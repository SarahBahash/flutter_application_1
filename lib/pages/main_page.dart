import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Add this package to your pubspec.yaml

import 'driver_page.dart';
import 'user_info_dialog.dart';
import 'previous_reservations_dialog.dart';
import 'lounge_selection_page.dart';
import 'personal_companion_service_page.dart';
import 'reserve_parking_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Welcome to King Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBDEFB), Color.fromARGB(255, 119, 191, 250)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Choose a Service',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Service Cards
                _buildServiceCard(
                  context,
                  title: 'Book a Driver',
                  description: 'Hire a professional driver at your service.',
                  icon: Icons.directions_car,
                  shimmerColor: Colors.greenAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildServiceCard(
                  context,
                  title: 'Book a Lounge',
                  description: 'Relax in luxury at our airport lounges.',
                  icon: Icons.airline_seat_recline_extra,
                  shimmerColor: Colors.purpleAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoungeSelectionPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildServiceCard(
                  context,
                  title: 'Personal Companion Service',
                  description: 'A personal assistant for your journey.',
                  icon: Icons.person,
                  shimmerColor: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PersonalCompanionServicePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildServiceCard(
                  context,
                  title: 'Reserve Parking',
                  description: 'Secure your parking spot in advance.',
                  icon: Icons.local_parking,
                  shimmerColor: Colors.redAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReserveParkingPage(),
                      ),
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

  // Service Card Builder
  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color shimmerColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        shadowColor: shimmerColor.withOpacity(0.3),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white70],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Shimmer effect on the icon
              Shimmer.fromColors(
                baseColor: shimmerColor,
                highlightColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: shimmerColor.withOpacity(0.5),
                  radius: 30,
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
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

// Dialog for Options
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'More Options',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Previous Reservations'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => const PreviousReservationsDialog(),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
