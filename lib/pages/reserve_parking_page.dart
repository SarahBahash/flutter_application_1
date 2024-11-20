import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class ReserveParkingPage extends StatefulWidget {
  const ReserveParkingPage({super.key});

  @override
  _ParkingReservationPageState createState() => _ParkingReservationPageState();
}

class _ParkingReservationPageState extends State<ReserveParkingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  // Controllers for date and time
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedDurationUnit = 'hour'; // Default unit
  int? selectedDurationValue;

  String? nameError;
  String? phoneError;
  String? vehicleNumberError;
  String? emailError;
  String? dateError;
  String? timeError;
  String? parkingError;
  String? durationError;

  int? selectedParkingSpot;

  final List<int> parkingSpots =
      List<int>.generate(20, (index) => index + 1); // 20 parking spots

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleNumberController.dispose();
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
        _dateController.text =
            DateFormat.yMMMd().format(pickedDate); // Update controller
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
        _timeController.text = pickedTime.format(context); // Update controller
        timeError = null;
      });
    }
  }

  Future<void> _submitReservation() async {
    setState(() {
      // Validate all fields
      nameError = _nameController.text.isEmpty ? 'Name cannot be empty' : null;
      phoneError =
          _phoneController.text.isEmpty ? 'Phone number cannot be empty' : null;
      emailError =
          _emailController.text.isEmpty ? 'Email cannot be empty' : null;
      vehicleNumberError = _vehicleNumberController.text.isEmpty
          ? 'Vehicle number cannot be empty'
          : null;
      dateError = selectedDate == null ? 'Please select a date' : null;
      timeError = selectedTime == null ? 'Please select a time' : null;
      parkingError =
          selectedParkingSpot == null ? 'Please select a parking spot' : null;
      durationError =
          selectedDurationValue == null ? 'Please select a duration' : null;
    });

    if ([
      nameError,
      phoneError,
      emailError,
      vehicleNumberError,
      dateError,
      timeError,
      parkingError,
      durationError
    ].every((error) => error == null)) {
      try {
        final url = Uri.parse('http://10.0.2.2:6000/api/reserve-parking');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "user_name": _nameController.text,
            "phone": _phoneController.text,
            "email": _emailController.text,
            "vehicle_number": _vehicleNumberController.text,
            "reservation_date": DateFormat('yyyy-MM-dd').format(selectedDate!),
            "start_time": formatTimeOfDay(selectedTime!),
            "parking_slot": selectedParkingSpot,
            "time_period": "$selectedDurationValue $selectedDurationUnit"
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

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservation Period:',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedDurationUnit,
              items: [
                DropdownMenuItem(value: 'hour', child: const Text('Hour(s)')),
                DropdownMenuItem(value: 'day', child: const Text('Day(s)')),
                DropdownMenuItem(value: 'week', child: const Text('Week(s)')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDurationUnit = value!;
                  selectedDurationValue = null; // Reset value
                });
              },
            ),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedDurationValue,
              items: _generateDurationValues(selectedDurationUnit!)
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text('$value')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDurationValue = value!;
                  durationError = null;
                });
              },
            ),
          ],
        ),
        if (durationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              durationError!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  List<int> _generateDurationValues(String unit) {
    switch (unit) {
      case 'hour':
        return List<int>.generate(11, (index) => index + 1); // 1-9 hours
      case 'day':
        return List<int>.generate(6, (index) => index + 1); // 1-6 days
      case 'week':
        return List<int>.generate(4, (index) => index + 1); // 1-4 weeks
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Reserve a Parking Spot',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: const OutlineInputBorder(),
                      errorText: nameError,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: const OutlineInputBorder(),
                      errorText: phoneError,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: const OutlineInputBorder(),
                      errorText: emailError,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _vehicleNumberController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Number',
                      border: const OutlineInputBorder(),
                      errorText: vehicleNumberError,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dateController, // Use the controller
                        decoration: InputDecoration(
                          labelText: 'Arrival Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
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
                        controller: _timeController, // Use the controller
                        decoration: InputDecoration(
                          labelText: 'Arrival Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.access_time),
                          errorText: timeError,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildDurationSelector(),
                  const SizedBox(height: 20),
                  const Text(
                    'Select a Parking Spot:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: parkingSpots.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final spotNumber = parkingSpots[index];
                      final isSelected = selectedParkingSpot == spotNumber;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedParkingSpot = spotNumber;
                            parkingError = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$spotNumber',
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (parkingError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      parkingError!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
      ),
    );
  }
}
