import 'package:flutter/material.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  String? _selectedTerminal;
  TimeOfDay? _pickupTime;

  final List<String> _terminals = ['Terminal 1', 'Terminal 2'];

  void _reserve() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservation Details'),
        content: Text(
          'City: ${_cityController.text}\nStreet: ${_streetController.text}\nPostcode: ${_postcodeController.text}\nTerminal: $_selectedTerminal\nPickup: ${_pickupTime?.format(context)}',
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
