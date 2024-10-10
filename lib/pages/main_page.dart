import 'package:flutter/material.dart';
import 'driver_page.dart';
import 'user_info_dialog.dart';
import 'previous_reservations_dialog.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Colors.blue[800], // Dark blue for the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // White background for the body
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo2.png', // Add your logo image here
                  height: 200, // Adjust height as needed
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose a service',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverPage()),
                    );
                  },
                  child: const Text('Book a Driver'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for future functionality
                  },
                  child: const Text('Other Functionality'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('View User Info'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  showDialog(
                    context: context,
                    builder: (context) => const UserInfoDialog(),
                  );
                },
              ),
              ListTile(
                title: const Text('View Previous Reservations'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
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
