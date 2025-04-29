import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class AdsCarousel extends StatefulWidget {
  final List<String> adImages;
  final double height;
  final double viewportFraction;

  const AdsCarousel({
    super.key,
    required this.adImages,
    this.height = 180,
    this.viewportFraction = 0.9, required Future? Function() onTap,
  });

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  int _currentSlideIndex = 0;

  Widget _buildCarouselItem(String imageUrl, int index) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 10),
      color: Colors.white,
      child: Stack(
        children: [
          FlutterCarousel(
            items: widget.adImages.asMap().entries.map((entry) {
              return _buildCarouselItem(entry.value, entry.key);
            }).toList(),
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: widget.viewportFraction,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              pauseAutoPlayOnTouch: true,
              onPageChanged: (index, reason) {
                setState(() => _currentSlideIndex = index);
              },
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.adImages.asMap().entries.map((entry) {
                return Container(
                  width: 20,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  color: Colors.white.withOpacity(
                    _currentSlideIndex == entry.key ? 0.9 : 0.3,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}