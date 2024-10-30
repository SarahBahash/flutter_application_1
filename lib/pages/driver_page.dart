import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // New email controller
  String? _selectedTerminal;
  TimeOfDay? _pickupTime;

  final List<String> _terminals = ['Terminal 1', 'Terminal 2'];

  void _reserve() {
// Check if any fields are empty
    if (_cityController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _postcodeController.text.isEmpty ||
        _emailController.text.isEmpty || // Check if email is filled
        _selectedTerminal == null ||
        _pickupTime == null) {
// Show an error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill all fields before reserving.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit the method early
    }

// Proceed to show reservation details if everything is filled
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservation Details'),
        content: Text(
          'City: ${_cityController.text}\n'
          'Street: ${_streetController.text}\n'
          'Postcode: ${_postcodeController.text}\n'
          'Email: ${_emailController.text}\n' // Include email in details
          'Terminal: $_selectedTerminal\n'
          'Pickup: ${_pickupTime?.format(context)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Reservation'),
        backgroundColor: Colors.blue[800], // Dark blue for the AppBar
      ),
      body: Container(
        color: Colors.white, // White for the body
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'KING ABDULAZIZ AIRPORT Private Driver Service',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  TextField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Street'),
                  ),
                  TextField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(labelText: 'Postcode'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _emailController, // Email input field
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select Terminal'),
                    value: _selectedTerminal,
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
                  ),
                  ElevatedButton(
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
                    child: const Text('Select Pickup Time'),
                  ),
                  const SizedBox(
                      height: 20), // Add space before the reserve button
                  ElevatedButton(
                    onPressed: _reserve,
                    child: const Text('Reserve'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
