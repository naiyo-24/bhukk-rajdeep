import 'dart:async';
import 'package:get/get.dart';
import '../models/carousel.dart';
import '../repositories/carousel_repository.dart';

class BhukkCarouselController extends GetxController {
  final CarouselRepository _repository;
  Timer? _refreshTimer;
  
  BhukkCarouselController({CarouselRepository? repository}) 
    : _repository = repository ?? CarouselRepository();
  
  final RxList<Carousel> carousels = <Carousel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool hasData = false.obs;
  final RxString errorMessage = "".obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCarousels();
    // Start a periodic timer to refresh carousel data every 10 seconds
    _startPeriodicRefresh();
  }
  
  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    _refreshTimer?.cancel();
    super.onClose();
  }
  
  // Start periodic refresh of carousel data
  void _startPeriodicRefresh() {
    // Cancel any existing timer first
    _refreshTimer?.cancel();
    // Create a new timer that calls fetchCarousels every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      print('Refreshing carousel data automatically');
      _refreshCarouselsQuietly();
    });
  }
  
  // Refresh carousels without showing loading state
  Future<void> _refreshCarouselsQuietly() async {
    try {
      final result = await _repository.getCarousels();
      
      if (result.isNotEmpty) {
        // Only include active carousels and ensure they're sorted by position
        final sortedCarousels = result.where((carousel) => carousel.isActive).toList()
          ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
        
        if (sortedCarousels.isNotEmpty) {
          carousels.assignAll(sortedCarousels);
          hasData.value = true;
          hasError.value = false;
          errorMessage.value = "";
        }
      }
    } catch (e) {
      // Don't update error states for quiet refresh
      print('Silent refresh error: $e');
    }
  }
  
  Future<void> fetchCarousels() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      hasData.value = false;
      errorMessage.value = "";
      
      final result = await _repository.getCarousels();
      carousels.clear();
      
      if (result.isEmpty) {
        // No carousels data from API
        hasData.value = false;
        errorMessage.value = "No carousel data available. Pull down to refresh.";
      } else {
        // Only include active carousels and ensure they're sorted by position
        final sortedCarousels = result.where((carousel) => carousel.isActive).toList()
          ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
        
        if (sortedCarousels.isEmpty) {
          hasData.value = false;
          errorMessage.value = "No active carousels available.";
        } else {
          carousels.assignAll(sortedCarousels);
          hasData.value = true;
        }
      }
    } catch (e, stackTrace) {
      hasError.value = true;
      hasData.value = false;
      errorMessage.value = "Unable to load carousel data. Please try again later.";
      print('Error in controller: $e');
      print('Stack trace: $stackTrace');
      
      // Add fallback images on error to provide some content
      carousels.assignAll(List.generate(3, (i) => Carousel(
        id: i,
        position: i,
        isActive: true,
        imageUrl: 'assets/images/ad${i + 1}.jpg'
      )));
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to retry loading carousels
  void retryLoading() {
    fetchCarousels();
  }
}
