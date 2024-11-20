import 'package:flutter/material.dart';

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
        title: const Text('Book Your Lounge'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fill in your details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Full Name Field
                _buildTextField(
                  label: "Full Name",
                  hintText: "Enter your full name",
                  icon: Icons.person,
                  onSave: (value) => _fullName = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Full name is required"
                      : null,
                ),

                const SizedBox(height: 16),

                // Email Field
                _buildTextField(
                  label: "Email",
                  hintText: "Enter your email address",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onSave: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Phone Number Field
                _buildTextField(
                  label: "Phone Number",
                  hintText: "Enter your phone number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onSave: (value) => _phoneNumber = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Phone number is required"
                      : null,
                ),

                const SizedBox(height: 16),

                // Departure Date Field
                _buildDatePickerField(
                  label: "Departure Date",
                  icon: Icons.calendar_today,
                  selectedDate: _departureDateTime,
                  onDatePicked: (pickedDate) {
                    setState(() {
                      _departureDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        _departureDateTime?.hour ?? 0,
                        _departureDateTime?.minute ?? 0,
                      );
                    });
                  },
                  validator: () => _departureDateTime == null
                      ? "Please select a departure date"
                      : null,
                ),

                const SizedBox(height: 16),

                // Departure Time Field
                _buildTimePickerField(
                  label: "Departure Time",
                  icon: Icons.access_time,
                  selectedDateTime: _departureDateTime,
                  onTimePicked: (pickedTime) {
                    setState(() {
                      _departureDateTime = DateTime(
                        _departureDateTime?.year ?? DateTime.now().year,
                        _departureDateTime?.month ?? DateTime.now().month,
                        _departureDateTime?.day ?? DateTime.now().day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  },
                  validator: () => _departureDateTime == null
                      ? "Please select a departure time"
                      : null,
                ),

                const SizedBox(height: 16),

                // Lounge Selection Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Lounge",
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.airline_seat_recline_extra),
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
                  validator: (value) =>
                      value == null ? "Please select a lounge" : null,
                ),

                const SizedBox(height: 30),

                // Book Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _showReservationDetails();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Book Lounge',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required void Function(String?) onSave,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSave,
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required Function(DateTime) onDatePicked,
    required String? Function()? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null
            ? '${selectedDate.toLocal()}'.split(' ')[0]
            : '',
      ),
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
      validator: (_) =>
          validator != null ? validator() : null, // Fixed validator
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required IconData icon,
    required DateTime? selectedDateTime,
    required Function(TimeOfDay) onTimePicked,
    required String? Function()? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: selectedDateTime != null
            ? '${selectedDateTime.hour}:${selectedDateTime.minute.toString().padLeft(2, '0')}'
            : '',
      ),
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          onTimePicked(pickedTime);
        }
      },
      validator: (_) =>
          validator != null ? validator() : null, // Fixed validator
    );
  }

  void _showReservationDetails() {
    final reservationDetails = {
      'Full Name': _fullName,
      'Email': _email,
      'Phone Number': _phoneNumber,
      'Lounge': _selectedLounge,
      'Departure Time': _departureDateTime?.toIso8601String(),
    };

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
