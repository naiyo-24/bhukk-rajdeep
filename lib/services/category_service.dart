// filepath: /Users/rohitghosh/Documents/Projects/bhukk-rajdeep/lib/services/category_service.dart
import 'package:dio/dio.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryService {
  final ApiService _apiService;

  CategoryService({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get('v1/categories/');
      
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => Category.fromJson(item))
            .toList();
      } else {
        print('Invalid response format: ${response.data}');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching categories: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }
}
