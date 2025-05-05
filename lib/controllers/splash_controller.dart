import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/carousel.dart';
import '../repositories/carousel_repository.dart';

class SplashController extends GetxController {
  final CarouselRepository _repository;
  final RxBool isLoading = true.obs;
  
  SplashController({CarouselRepository? repository})
      : _repository = repository ?? CarouselRepository();
  
  @override
  void onInit() {
    super.onInit();
    // Initialize loading state
    isLoading.value = true;
  }
  
  Future<void> preloadCarouselImages(BuildContext context) async {
    try {
      // Only load if not already loaded
      if (!Carousel.isImagesLoaded) {
        // Fetch carousels from repository
        final carousels = await _repository.getCarousels();
        // Preload all carousel images
        await Carousel.preloadImages(carousels, context);
      }
    } catch (e) {
      print('Error in splash controller: $e');
    } finally {
      // Mark loading as complete
      isLoading.value = false;
    }
  }
}
