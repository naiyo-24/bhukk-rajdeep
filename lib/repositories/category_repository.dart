// filepath: /Users/rohitghosh/Documents/Projects/bhukk-rajdeep/lib/repositories/category_repository.dart
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService;

  CategoryRepository({CategoryService? categoryService}) 
      : _categoryService = categoryService ?? CategoryService();

  Future<List<Category>> getCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      print('Repository received ${categories.length} categories');
      if (categories.isEmpty) {
        print('Warning: No categories received from service');
      }
      return categories;
    } catch (e, stackTrace) {
      print('Error in repository: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}
