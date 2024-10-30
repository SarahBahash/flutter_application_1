import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: const Text('Lounge One Form'),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Departure Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _departureDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        _departureDateTime?.hour ?? 0,
                        _departureDateTime?.minute ?? 0,
                      );
                    });
                  }
                },
                validator: (value) {
                  if (_departureDateTime == null) {
                    return 'Please select a departure date';
                  }
                  return null;
                },
                controller: TextEditingController(
                  text: _departureDateTime != null
                      ? '${_departureDateTime!.toLocal()}'.split(' ')[0]
                      : '',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Departure Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _departureDateTime = DateTime(
                        _departureDateTime?.year ?? DateTime.now().year,
                        _departureDateTime?.month ?? DateTime.now().month,
                        _departureDateTime?.day ?? DateTime.now().day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                validator: (value) {
                  if (_departureDateTime == null) {
                    return 'Please select a departure time';
                  }
                  return null;
                },
                controller: TextEditingController(
                  text: _departureDateTime != null
                      ? '${_departureDateTime!.hour}:${_departureDateTime!.minute}'
                      : '',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Lounge',
                  border: OutlineInputBorder(),
                ),
                items: lounges.map((lounge) {
                  return DropdownMenuItem(
                    value: lounge,
                    child: Text(lounge),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLounge = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a lounge';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _showReservationDetails();
                  }
                },
                child: const Text('Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReservationDetails() {
    // Prepare the reservation details
    final reservationDetails = {
      'Full Name': _fullName,
      'Email': _email,
      'Phone Number': _phoneNumber,
      'Lounge': _selectedLounge,
      'Departure Time': _departureDateTime?.toIso8601String(),
    };

    // Show reservation details dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservation Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: reservationDetails.entries.map((entry) {
            return Text('${entry.key}: ${entry.value}');
          }).toList(),
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
}
