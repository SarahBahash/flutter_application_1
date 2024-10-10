import 'package:flutter/material.dart';

class PreviousReservationsDialog extends StatelessWidget {
  const PreviousReservationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Previous Reservations'),
      content: const Text('Display previous reservations here.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
