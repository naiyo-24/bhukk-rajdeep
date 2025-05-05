import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carousel.dart';

class CarouselService {
  // Updated to the correct API endpoint
  final String apiUrl = 'http://localhost:8001/api/v1/carousel/';

  Future<List<Carousel>> getCarousels() async {
    try {
      print('Fetching carousels from: $apiUrl');
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        print('API Response received - Status: ${response.statusCode}');
        print('Full API Response: ${response.body}');
        
        final List<dynamic> jsonData = json.decode(response.body);
        print('Number of carousel items: ${jsonData.length}');
        
        // Print each carousel item for debugging
        for (var i = 0; i < jsonData.length; i++) {
          print('Carousel $i: ${jsonData[i]}');
        }
        
        // Map each JSON object to a Carousel model
        return jsonData.map((json) => Carousel.fromJson(json)).toList();
      } else {
        print('API error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Network error: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}
