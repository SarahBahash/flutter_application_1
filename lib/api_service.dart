import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/data')); // Updated for emulator

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['message']); // Output: Hello from Node.js!
    } else {
      print('Error: ${response.statusCode}'); // Print status code for debugging
      throw Exception('Failed to load data');
    }
  }
}
