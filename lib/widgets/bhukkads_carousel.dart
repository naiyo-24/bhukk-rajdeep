import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BhukkadsCarousel extends StatefulWidget {
  const BhukkadsCarousel({super.key});

  @override
  State<BhukkadsCarousel> createState() => _BhukkadsCarouselState();
}

class _BhukkadsCarouselState extends State<BhukkadsCarousel> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'assets/images/partner.png',
      'title': 'Want to be a Delivery Partner?',
      'description': 'Join us and earn extra income',
    },
   
    
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: null,
          itemCount: carouselItems.length,
          options: CarouselOptions(
            height: 400,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    Image.asset(
                      carouselItems[index]['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            carouselItems[index]['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            carouselItems[index]['description'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: carouselItems.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Theme.of(context).primaryColor,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
