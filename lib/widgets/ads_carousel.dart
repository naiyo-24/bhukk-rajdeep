import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/carousel.dart';
import 'shimmer_carousel.dart';

class AdsCarousel extends StatefulWidget {
  final List<Carousel> carousels;
  final double height;
  final double viewportFraction;
  final Function(String? link) onTap;

  const AdsCarousel({
    Key? key,
    required this.carousels,
    this.height = 200,
    this.viewportFraction = 0.8,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  int _current = 0;
  final Map<int, bool> _loadedImages = {};
  bool _isCarouselReady = false;

  @override
  void initState() {
    super.initState();
    // Initialize carousels as ready if we have data
    if (widget.carousels.isNotEmpty) {
      // Set a small delay to prevent immediate shimmer flash
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _isCarouselReady = true;
          });
        }
      });
    }
  }

  void _checkCarouselReadiness() {
    // If we have carousels, consider it ready to display
    if (widget.carousels.isNotEmpty) {
      setState(() {
        _isCarouselReady = true;
      });
    } else {
      setState(() {
        _isCarouselReady = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show shimmer while loading images
    if (!_isCarouselReady) {
      return SizedBox(
        height: widget.height,
        child: const ShimmerCarousel(),
      );
    }
    
    // Handle empty carousel case
    if (widget.carousels.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Oops! No carousel data available.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  // This will trigger rebuild when parent refreshes
                  if (mounted) {
                    setState(() {
                      _isCarouselReady = false;
                      _loadedImages.clear();
                    });
                  }
                },
                icon: const Icon(Icons.refresh, color: Colors.deepOrangeAccent),
                label: const Text(
                  'Reload',
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.carousels.length,
          itemBuilder: (context, index, realIndex) {
            final carousel = widget.carousels[index];
            return GestureDetector(
              onTap: () => widget.onTap(carousel.link),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!_loadedImages.containsKey(index) || !_loadedImages[index]!)
                        const ShimmerCarousel(),
                      
                      Image.network(
                        carousel.imageUrl ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            Future.microtask(() {
                              if (mounted) {
                                setState(() {
                                  _loadedImages[index] = true;
                                });
                                _checkCarouselReadiness();
                              }
                            });
                            return child;
                          }
                          return Container();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          Future.microtask(() {
                            if (mounted) {
                              setState(() {
                                _loadedImages[index] = true;
                              });
                              _checkCarouselReadiness();
                            }
                          });
                          return Image.asset(
                            'assets/images/ad1.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),

                      if (_loadedImages.containsKey(index) && _loadedImages[index]!)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),

                      if (_loadedImages.containsKey(index) && _loadedImages[index]!)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (carousel.title != null && carousel.title!.isNotEmpty)
                                Text(
                                  carousel.title!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                              if (carousel.subtitle != null && carousel.subtitle!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    carousel.subtitle!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: widget.viewportFraction,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16/9,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.carousels.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _current = entry.key;
                });
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrangeAccent.withOpacity(
                    _current == entry.key ? 0.9 : 0.4
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

