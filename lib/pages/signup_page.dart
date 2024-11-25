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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Page Title
              const Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign up to start your journey!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              // Sign-Up Form
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                        nameController, 'Full Name', false, Icons.person),
                    const SizedBox(height: 20),
                    _buildTextField(
                        ageController, 'Age', false, Icons.calendar_today,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(
                        emailController, 'Email Address', false, Icons.email),
                    const SizedBox(height: 20),
                    _buildTextField(
                        phoneController, 'Phone Number', false, Icons.phone,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 20),
                    _buildTextField(
                        passwordController, 'Password', true, Icons.lock),
                    const SizedBox(height: 30),
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
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Already Have an Account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
      _showDialog(context, 'Failed to sign up. Please try again.');
    }
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Widget _buildTextField(TextEditingController controller, String label,
      bool isPassword, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue[800]),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        filled: true,
        fillColor: Colors.blue.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue.shade800, width: 2.0),
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
      name: json['name'] ?? 'Unknown',
      age: json['age'] ?? 0,
      email: json['email'] ?? 'unknown@example.com',
      phone: json['phone'] ?? 'N/A',
      userId: json['id'] ?? -1,
    );
  }
}
