import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'dart:convert'; // Import for JSON encoding/decoding

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Call the login function
                    final success = await _login(
                      emailController.text,
                      passwordController.text,
                    );

                    if (success) {
                      // Navigate to the main page
                      Navigator.pushReplacementNamed(context, '/main');
                    } else {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid email or password'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[800],
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:4000/api/login');

    // Log the email and password being sent
    print('Attempting login with email: $email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
      obscureText: isPassword,
    );
  }
}
