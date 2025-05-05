import '../models/carousel.dart';
import '../services/carousel_service.dart';

class CarouselRepository {
  final CarouselService _carouselService;

  CarouselRepository({CarouselService? carouselService}) 
      : _carouselService = carouselService ?? CarouselService();

  Future<List<Carousel>> getCarousels() async {
    try {
      final carousels = await _carouselService.getCarousels();
      print('Repository received ${carousels.length} carousels');
      if (carousels.isEmpty) {
        print('Warning: No carousels received from service');
      }
      return carousels;
    } catch (e, stackTrace) {
      print('Error in repository: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}
