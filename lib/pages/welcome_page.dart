import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to JetSetGo'),
        backgroundColor: Colors.blue[800], // AppBar color
      ),
      body: Container(
        color: Colors.white, // White background for the body
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align items
              children: [
                Image.asset(
                  'assets/logo2.png',
                  height: 450, // Adjust height as needed
                ),
                const SizedBox(height: 30), // Increased spacing
                const Text(
                  'if you do not have an Account please sign up',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.black87, // Text color
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30), // Increased spacing
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.blue[800], // Text color in the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Padding
                    textStyle: const TextStyle(fontSize: 18), // Font size
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.blue[800], // Text color in the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Padding
                    textStyle: const TextStyle(fontSize: 18), // Font size
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
}
