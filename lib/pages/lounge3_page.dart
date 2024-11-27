import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        title: const Text('Lounge 1'),
        backgroundColor: const Color(0xFF4A8AD4), // Consistent theme color
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDAE9F7), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Carousel Slider for Images
              CarouselSlider(
                items: images.map((image) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                ),
              ),
              const SizedBox(height: 20),

              // Information Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Some lounges may require eligibility verification at the entrance. Please ensure you have the required credentials.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Accepted VISA Types Header
              const Text(
                'Accepted VISA Types:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A8AD4),
                ),
              ),
              const SizedBox(height: 10),

              // Display VISA Types as Plain Text List
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: acceptedVisaTypes.map((type) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '- $type',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      // Sticky Button at the Bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoungeOneForm()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A8AD4),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: const Text(
            'Go to Lounge Form',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
