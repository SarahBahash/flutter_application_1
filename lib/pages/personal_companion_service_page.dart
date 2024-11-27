import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for json encoding
import 'dart:math';

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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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
        _dateController.text = DateFormat.yMMMd().format(pickedDate);
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
        _timeController.text = pickedTime.format(context);
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

    if ([nameError, emailError, phoneError, dateError, timeError]
        .every((error) => error == null)) {
      try {
        final random = Random();
        final randomStaff = staffNames[random.nextInt(staffNames.length)];
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
            "staff": randomStaff,
            "passenger_type": isChildSelected ? "Child" : "Special needs",
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
            SnackBar(content: Text('Failed to reserve: $error')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
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
        title: const Text('Personal Companion Service'),
        backgroundColor: const Color(0xFF4A8AD4),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6CBDFC), Color(0xFFF4F6F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Personal Companion Service',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A8AD4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildSwitchRow(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      errorText: nameError,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      errorText: phoneError,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildDatePickerField(
                      controller: _dateController,
                      label: 'Arrival Date',
                      errorText: dateError,
                      icon: Icons.calendar_today,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    _buildDatePickerField(
                      controller: _timeController,
                      label: 'Arrival Time',
                      errorText: timeError,
                      icon: Icons.access_time,
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _confirmReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A8AD4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Reserve',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }

  Widget _buildSwitchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Special needs (Elderly)', style: TextStyle(fontSize: 16)),
        Switch(
          value: isChildSelected,
          onChanged: (value) {
            setState(() {
              isChildSelected = value;
            });
          },
          activeColor: const Color(0xFF4A8AD4),
          inactiveTrackColor: Colors.grey[300],
        ),
        const Text('Child', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(icon, color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
