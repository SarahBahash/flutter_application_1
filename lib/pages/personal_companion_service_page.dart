import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for json encoding

class PersonalCompanionServicePage extends StatefulWidget {
  const PersonalCompanionServicePage({super.key});

  @override
  _PersonalCompanionServicePageState createState() =>
      _PersonalCompanionServicePageState();
}

class _PersonalCompanionServicePageState
    extends State<PersonalCompanionServicePage> {
  bool isChildSelected = false;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variables to store selected date and time
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Error messages
  String? nameError;
  String? emailError;
  String? phoneError;
  String? dateError;
  String? timeError;

  // List of staff names (not displayed)
  final List<String> staffNames = [
    'Khaled Mohammed',
    'Sarah Bahashwan',
    'Deema Alsini',
    'Abdullah Ali',
    'Abdulaziz Khaled',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateError = null;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        timeError = null;
      });
    }
  }

  Future<void> _confirmReservation() async {
    setState(() {
      nameError = _nameController.text.isEmpty ? 'Name cannot be empty' : null;
      emailError =
          _emailController.text.isEmpty ? 'Email cannot be empty' : null;
      phoneError =
          _phoneController.text.isEmpty ? 'Phone number cannot be empty' : null;
      dateError = selectedDate == null ? 'Please select an arrival date' : null;
      timeError = selectedTime == null ? 'Please select an arrival time' : null;
    });

    if ([
      nameError,
      emailError,
      phoneError,
      dateError,
      timeError,
    ].every((error) => error == null)) {
      try {
        final url =
            Uri.parse('http://10.0.2.2:6000/api/reserve-personal-companion');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": _nameController.text,
            "email": _emailController.text,
            "phone": _phoneController.text,
            "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
            "time": formatTimeOfDay(selectedTime!),
            "staff": staffNames[0], // Example: using the first staff member
          }),
        );
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reservation Confirmed'),
              content: Text('Reservation ID: ${data['id']}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to reserve: $error')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')));
        print(e);
      }
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
        title: const Text('Personal Companion Service'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Type:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Child'),
                    Switch(
                      value: isChildSelected,
                      onChanged: (value) {
                        setState(() {
                          isChildSelected = value;
                        });
                      },
                      activeColor: Colors.blue[800],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                    const Text('Adult'),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: nameError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: emailError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: phoneError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Arrival Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                        hintText: selectedDate != null
                            ? DateFormat.yMMMd().format(selectedDate!)
                            : 'Select a date',
                        errorText: dateError,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Arrival Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: const Icon(Icons.access_time),
                        hintText: selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Select a time',
                        errorText: timeError,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _confirmReservation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Reserve',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
