import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoungeOneForm extends StatefulWidget {
  const LoungeOneForm({super.key});

  @override
  _LoungeOneFormState createState() => _LoungeOneFormState();
}

class _LoungeOneFormState extends State<LoungeOneForm> {
  final _formKey = GlobalKey<FormState>();

  String? _fullName;
  String? _email;
  String? _phoneNumber;
  DateTime? _departureDateTime;
  String? _selectedLounge;

  final List<String> lounges = ['AL Fursan', 'Plaza', 'Wellcome'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lounge Booking'),
        backgroundColor: const Color(0xFF2F63C5),
        elevation: 2,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6CBDFC), Color(0xFFF4F6F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Book Your Lounge',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Secure your lounge reservation with the form below.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          label: "Full Name",
                          icon: Icons.person_outline,
                          onSave: (value) => _fullName = value,
                          validator: (value) => value == null || value.isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onSave: (value) => _email = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                .hasMatch(value)) {
                              return "Invalid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          onSave: (value) => _phoneNumber = value,
                          validator: (value) => value == null || value.isEmpty
                              ? "Phone number is required"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDatePickerField(
                          label: "Departure Date",
                          icon: Icons.calendar_today_outlined,
                          onDatePicked: (pickedDate) {
                            setState(() {
                              _departureDateTime = pickedDate;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Select Lounge",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(
                              Icons.airline_seat_recline_extra_outlined,
                              color: Colors.black87,
                            ),
                          ),
                          items: lounges.map((lounge) {
                            return DropdownMenuItem(
                              value: lounge,
                              child: Text(lounge),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedLounge = value),
                          validator: (value) =>
                              value == null ? "Please select a lounge" : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2458B8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 4,
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required void Function(String?) onSave,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSave,
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required IconData icon,
    required Function(DateTime) onDatePicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          onDatePicked(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(icon, color: Colors.black),
          ),
          controller: TextEditingController(
            text: _departureDateTime != null
                ? _departureDateTime!.toLocal().toString().split(' ')[0]
                : '',
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if date is selected before proceeding
      if (_departureDateTime == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please select a departure date.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final reservationData = {
        'name': _fullName,
        'email': _email,
        'phone': _phoneNumber,
        'lounge_name': _selectedLounge,
        'departure_time': _departureDateTime?.toIso8601String(),
      };

      try {
        // Show loading indicator while waiting for the response
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing while waiting
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final response = await http.post(
          Uri.parse(
              'http://10.0.2.2:6000/api/reserve-lounge'), // Ensure correct URL
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(reservationData),
        );

        Navigator.of(context).pop(); // Close the loading indicator

        if (response.statusCode == 201) {
          // Reservation successful
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reservation Confirmed'),
              content: Text(
                "Name: $_fullName\nEmail: $_email\nPhone: $_phoneNumber\n"
                "Lounge: $_selectedLounge\nDeparture: $_departureDateTime",
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
          // Error during reservation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reservation Failed'),
              content: Text('Error: ${response.body}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (error) {
        // Handle any errors that occur during the request
        print('Error during request: $error');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Request Error'),
            content: Text('An error occurred: $error'),
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
  }
}
