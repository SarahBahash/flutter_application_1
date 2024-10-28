import 'package:flutter/material.dart';

class LoungeOneForm extends StatefulWidget {
  const LoungeOneForm({super.key});

  @override
  _LoungeOneFormState createState() => _LoungeOneFormState();
}

class _LoungeOneFormState extends State<LoungeOneForm> {
  final _formKey = GlobalKey<FormState>();

  String? _fullName;
  String? _phoneNumber;
  DateTime? _departureTime;
  String? _selectedLounge;

  // List of lounges
  final List<String> lounges = ['Lounge 1', 'Lounge 2', 'Lounge 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lounge One Form'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
                      _departureTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                validator: (value) {
                  if (_departureTime == null) {
                    return 'Please select a departure time';
                  }
                  return null;
                },
                controller: TextEditingController(
                  text: _departureTime != null
                      ? '${_departureTime!.hour}:${_departureTime!.minute}'
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Navigate to the booking details page or show booking details
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Booking Details'),
                        content: Text(
                          'Name: $_fullName\n'
                          'Phone: $_phoneNumber\n'
                          'Departure Time: ${_departureTime?.hour}:${_departureTime?.minute}\n'
                          'Selected Lounge: $_selectedLounge',
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
                },
                child: const Text('Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
