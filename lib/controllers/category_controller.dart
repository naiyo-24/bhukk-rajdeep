// filepath: /Users/rohitghosh/Documents/Projects/bhukk-rajdeep/lib/controllers/category_controller.dart
import 'package:get/get.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository;
  
  CategoryController({CategoryRepository? repository}) 
    : _repository = repository ?? CategoryRepository();
  
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = "";
      
      final data = await _repository.getCategories();
      
      categories.clear();
      categories.addAll(data);
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to load categories: $e";
      print("Error loading categories: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  void refreshCategories() {
    fetchCategories();
  }
}
