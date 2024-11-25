import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreviousReservationsDialog extends StatefulWidget {
  const PreviousReservationsDialog({super.key});

  @override
  _PreviousReservationsDialogState createState() =>
      _PreviousReservationsDialogState();
}

class _PreviousReservationsDialogState
    extends State<PreviousReservationsDialog> {
  final TextEditingController _emailController = TextEditingController();
  Map<String, dynamic> _reservations = {};
  bool _isLoading = false;

  Future<void> _fetchReservations() async {
    setState(() {
      _isLoading = true;
      _reservations = {};
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:6000/api/get-reservations'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': _emailController.text}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          setState(() {
            _reservations = responseData['data'];
          });
        } else {
          _showMessage(responseData['message'] ?? 'No reservations found.');
        }
      } else {
        _showMessage('Failed to fetch reservations. Try again.');
      }
    } catch (e) {
      print('Error occurred: $e');
      _showMessage('An error occurred. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Previous Reservations'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : _reservations.isEmpty
                    ? const Text('No reservations to display.')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_reservations['driver_reservations'] != null &&
                              _reservations['driver_reservations'].isNotEmpty)
                            _buildReservationSection(
                              title: 'Driver Reservations',
                              reservations:
                                  _reservations['driver_reservations'],
                            ),
                          if (_reservations['lounge_reservations'] != null &&
                              _reservations['lounge_reservations'].isNotEmpty)
                            _buildReservationSection(
                              title: 'Lounge Reservations',
                              reservations:
                                  _reservations['lounge_reservations'],
                            ),
                          if (_reservations['parking_reservations'] != null &&
                              _reservations['parking_reservations'].isNotEmpty)
                            _buildReservationSection(
                              title: 'Parking Reservations',
                              reservations:
                                  _reservations['parking_reservations'],
                            ),
                          if (_reservations[
                                      'personal_companion_reservations'] !=
                                  null &&
                              _reservations['personal_companion_reservations']
                                  .isNotEmpty)
                            _buildReservationSection(
                              title: 'Personal Companion Reservations',
                              reservations: _reservations[
                                  'personal_companion_reservations'],
                            ),
                        ],
                      ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _fetchReservations,
          child: const Text('Search'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildReservationSection({
    required String title,
    required List<dynamic>? reservations,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Column(
            children: reservations!.map((reservation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _formatReservation(reservation),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatReservation(Map<String, dynamic> reservation) {
    return reservation.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
  }
}
