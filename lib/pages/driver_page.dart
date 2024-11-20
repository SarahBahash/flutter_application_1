import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for json encoding
import 'dart:math'; // Import this at the top of the file

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedTerminal;
  TimeOfDay? _pickupTime;

  final List<String> _terminals = ['Terminal 1', 'Terminal 2'];
  final _formKey = GlobalKey<FormState>();

  // List of staff names (not displayed)
  final List<String> driverNames = [
    'Khaled Mohammed',
    'Sarah Bahashwan',
    'Deema Alsini',
    'Abdullah Ali',
    'Abdulaziz Khaled',
  ];

  void _reserve() async {
    if (!_formKey.currentState!.validate()) {
      return; // Exit early if the form is invalid
    }
    final random = Random();
    final randomdriver = driverNames[random.nextInt(driverNames.length)];

    // Send the reservation data to the server
    try {
      final url = Uri.parse('http://10.0.2.2:6000/api/reserve-driver');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'city': _cityController.text,
          'street': _streetController.text,
          'postcode': _postcodeController.text,
          'email': _emailController.text,
          'terminal': _selectedTerminal,
          'pickup_time': formatTimeOfDay(_pickupTime!),
          "driver": randomdriver, // Example: using the first staff member
        }),
      );

      if (response.statusCode == 201) {
        // If the server returns a 201 Created response, show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Reservation successful!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle server errors
        throw Exception('Failed to make reservation');
      }
    } catch (e) {
      // Show error dialog if something goes wrong
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to make reservation. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Function to format TimeOfDay to "HH:mm:ss"
  String formatTimeOfDay(TimeOfDay time) {
    String hours = time.hour.toString().padLeft(2, '0'); // Zero-padded hours
    String minutes =
        time.minute.toString().padLeft(2, '0'); // Zero-padded minutes
    String seconds = "00"; // Default seconds to zero

    return "$hours:$minutes:$seconds"; // Return formatted time string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Reservation'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'KING ABDULAZIZ AIRPORT\nPrivate Driver Service',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(
                          labelText: 'Street',
                          prefixIcon: Icon(Icons.streetview),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Street is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _postcodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Postcode',
                          prefixIcon: Icon(Icons.local_post_office),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Postcode is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Terminal',
                          prefixIcon: Icon(Icons.flight_takeoff),
                          border: OutlineInputBorder(),
                        ),
                        items: _terminals.map((terminal) {
                          return DropdownMenuItem(
                            value: terminal,
                            child: Text(terminal),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTerminal = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a terminal';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.schedule),
                        label: const Text('Select Pickup Time'),
                        onPressed: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _pickupTime = time;
                            });
                          }
                        },
                      ),
                      if (_pickupTime != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Selected Time: ${_pickupTime!.format(context)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: _reserve,
                        child: const Text(
                          'Reserve',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
