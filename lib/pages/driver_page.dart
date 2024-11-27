import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedCity;
  String? _selectedTerminal;
  TimeOfDay? _pickupTime;

  final List<String> _cities = ['Jeddah', 'Makkah'];
  final List<String> _terminals = ['Terminal 1', 'Terminal 2'];
  final _formKey = GlobalKey<FormState>();

  final List<String> driverNames = [
    'Khaled Mohammed',
    'Sarah Bahashwan',
    'Deema Alsini',
    'Abdullah Ali',
    'Abdulaziz Khaled',
  ];

  void _reserve() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final random = Random();
    final randomDriver = driverNames[random.nextInt(driverNames.length)];

    try {
      final url = Uri.parse('http://10.0.2.2:6000/api/reserve-driver');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'city': _selectedCity,
          'street': _streetController.text,
          'postcode': _postcodeController.text,
          'email': _emailController.text,
          'terminal': _selectedTerminal,
          'pickup_time': formatTimeOfDay(_pickupTime!),
          'driver': randomDriver,
        }),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(
              'Your reservation is successful! Driver: $randomDriver',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to make reservation');
      }
    } catch (e) {
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

  String formatTimeOfDay(TimeOfDay time) {
    String hours = time.hour.toString().padLeft(2, '0');
    String minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes:00";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Reservation'),
        backgroundColor: Color(0xFF4A8AD4),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 90, 155, 230), Color(0xFFF5F7FA)],
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
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'KING ABDULAZIZ AIRPORT\nPrivate Driver Service',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // City Dropdown
                      _buildCityDropdownField(),
                      const SizedBox(height: 15),
                      // Street Field
                      _buildTextField(
                        controller: _streetController,
                        label: 'Street',
                        icon: Icons.streetview,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Street is required'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      // Postcode Field
                      _buildTextField(
                        controller: _postcodeController,
                        label: 'Postcode',
                        icon: Icons.local_post_office,
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Postcode is required'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // Terminal Dropdown
                      _buildDropdownField(
                        label: 'Select Terminal',
                        icon: Icons.flight_takeoff,
                        items: _terminals,
                        value: _selectedTerminal,
                        onChanged: (value) =>
                            setState(() => _selectedTerminal = value),
                        validator: (value) =>
                            value == null ? 'Please select a terminal' : null,
                      ),
                      const SizedBox(height: 15),
                      // Pickup Time Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.schedule),
                        label: const Text('Select Pickup Time'),
                        onPressed: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() => _pickupTime = time);
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
                      // Reserve Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A8AD4),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _reserve,
                        child: const Text(
                          'Reserve',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildCityDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'City',
        prefixIcon: const Icon(Icons.location_city, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
      },
      validator: (value) => value == null ? 'Please select a city' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    String? value,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Color(0xFF4A8AD4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      value: value,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
