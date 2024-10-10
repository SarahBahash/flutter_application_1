// TODO Implement this library.
import 'package:flutter/material.dart';

class UserInfoDialog extends StatelessWidget {
  const UserInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('User Information'),
      content: const Text('Display user info here.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
