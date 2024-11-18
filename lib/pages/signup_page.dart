import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                  'Sign Up',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildTextField(nameController, 'Name', false),
                const SizedBox(height: 20),
                _buildTextField(ageController, 'Age', false,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                _buildTextField(emailController, 'Email', false),
                const SizedBox(height: 20),
                _buildTextField(phoneController, 'Phone Number', false,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                _buildTextField(passwordController, 'Password', true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _signUp(
                      context,
                      nameController.text,
                      int.tryParse(ageController.text) ?? 0,
                      emailController.text,
                      phoneController.text,
                      passwordController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[800],
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context, String name, int age, String email,
      String phone, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:6000/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'age': age,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final userData = jsonDecode(response.body);
      User_Info currentUserInfo = User_Info.fromJson(userData);
      await saveUserId(currentUserInfo.userId);
      Navigator.pushReplacementNamed(context, '/main');
    } else if (response.statusCode == 409) {
      _showDialog(context, 'User already exists with this email.');
    } else {
      print('Failed to sign up: ${response.body}');
      _showDialog(context, 'Failed to sign up. Please try again.');
    }
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword,
      {TextInputType keyboardType = TextInputType.text}) {
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
      keyboardType: keyboardType,
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class User_Info {
  String name;
  int age;
  String email;
  String phone;
  int userId;

  User_Info({
    required this.name,
    required this.age,
    required this.email,
    required this.phone,
    required this.userId,
  });

  factory User_Info.fromJson(Map<String, dynamic> json) {
    return User_Info(
      name: json['name'] != null ? json['name'] as String : 'Unknown',
      age: json['age'] != null ? json['age'] as int : 0, // Handle null safely
      email: json['email'] != null
          ? json['email'] as String
          : 'unknown@example.com',
      phone: json['phone'] != null ? json['phone'] as String : 'N/A',
      userId: json['id'] != null ? json['id'] as int : -1,
    );
  }
}
