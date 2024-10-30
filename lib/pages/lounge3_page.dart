import 'package:flutter/material.dart';
import 'lounge_one_form.dart'; // Import the LoungeOneForm page

class Lounge3Page extends StatelessWidget {
  const Lounge3Page({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image assets
    final List<String> images = [
      'assets/lounge3_image.png',
      'assets/lounge3_image2.png',
      'assets/lounge3_image3.png',
      'assets/lounge3_image4.png',
      'assets/lounge3_image5.png',
    ];

    // List of accepted VISA types
    final List<String> acceptedVisaTypes = [
      'VISA Classic',
      'VISA Gold',
      'VISA Platinum',
      'VISA Signature',
      'VISA Infinite',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lounge 3'),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Space at the top
            // PageView for swiping images
            SizedBox(
              height: 220,
              width: 380,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please note: Some Lounges might not be accessible to you; eligibility will be checked at the entrance to the Lounges by the employee in charge.',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Accepted VISA Types List
            const Text(
              'Accepted VISA Types:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display the list of accepted VISA types
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: acceptedVisaTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(acceptedVisaTypes[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoungeOneForm()),
                );
              },
              child: const Text('Go to Lounges Form'),
            ),
          ],
        ),
      ),
    );
  }
}
