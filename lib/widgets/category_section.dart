// filepath: /Users/rohitghosh/Documents/Projects/bhukk-rajdeep/lib/widgets/category_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../models/category.dart';
import '../route/routes.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller instance or create it if it doesn't exist
    final CategoryController categoryController = Get.put(CategoryController());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(() {
          if (categoryController.isLoading.value) {
            return const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (categoryController.hasError.value) {
            return SizedBox(
              height: 160,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to load categories',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => categoryController.refreshCategories(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (categoryController.categories.isEmpty) {
            return const SizedBox(
              height: 160,
              child: Center(
                child: Text(
                  'No categories available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
          
          return SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) {
                final category = categoryController.categories[index];
                return _buildCategoryCard(category);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryCard(Category category) {
    final size = 90.0;
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.categoryItems,
        arguments: {'category': category.name},
      ),
      child: Container(
        width: size,
        height: size + 24,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(category.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
