import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Confetti> _confetti = [];
  final Random _random = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // animation timer set to 3  for sprinkles of ribbons
      vsync: this,
    )..addStatusListener(_handleAnimationStatus);
    _controller.forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _confetti.clear(); // Clear confetti when animation is done
      _initialized = false;
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    _confetti.clear();
    super.dispose();
  }

  void _initializeConfetti(BuildContext context) {
    if (_initialized) return;
    _initialized = true;

    final screenWidth = MediaQuery.of(context).size.width;
    final maxConfetti = (screenWidth / 2).floor(); // Increased density (was /4)
    
    for (int i = 0; i < maxConfetti; i++) {
      final gaussian = _generateGaussianNoise();
      final horizontalSpread = gaussian.dx * (screenWidth / 4); // Reduced spread
      final verticalOffset = gaussian.dy * 30; // Reduced vertical spread

      _confetti.add(Confetti(
        color: _generateFestiveColor(),
        position: Offset(
          screenWidth / 2 + horizontalSpread,
          -30 + verticalOffset,
        ),
        speed: 0.8 + _random.nextDouble() * 1.5, // Reduced speed (was 1.5 + random * 3)
        angle: _random.nextDouble() * 2 * pi,
        size: 5 + _random.nextDouble() * 10, // Slightly larger particles
        isGlitter: i % 2 == 0, // More glitter (was i % 3)
      ));
    }
  }

  Color _generateFestiveColor() {
    final festiveColors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFFFA500), // Orange
      const Color(0xFFFF69B4), // Pink
      const Color(0xFF00CED1), // Turquoise
      const Color(0xFFFF1493), // Deep Pink
      const Color(0xFF7B68EE), // Medium Slate Blue
    ];
    return festiveColors[_random.nextInt(festiveColors.length)]
        .withOpacity(0.8 + _random.nextDouble() * 0.2);
  }

  Offset _generateGaussianNoise() {
    final u1 = 1 - _random.nextDouble();
    final u2 = 1 - _random.nextDouble();
    final randStdNormal = sqrt(-2.0 * log(u1)) * cos(2 * pi * u2);
    return Offset(randStdNormal, randStdNormal);
  }

  @override
  Widget build(BuildContext context) {
    _initializeConfetti(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ConfettiPainter(
            confetti: _confetti,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class Confetti {
  final Color color;
  final Offset position;
  final double speed;
  final double angle;
  final double size;
  final bool isGlitter;

  Confetti({
    required this.color,
    required this.position,
    required this.speed,
    required this.angle,
    required this.size,
    required this.isGlitter,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter({required this.confetti, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in confetti) {
      final paint = Paint()
        ..color = particle.isGlitter 
            ? HSLColor.fromColor(particle.color)
                .withLightness((0.7 + sin(progress * 10) * 0.3).clamp(0.0, 1.0))
                .toColor()
            : particle.color
        ..style = particle.isGlitter ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = particle.isGlitter ? 2 : 1;

      final position = Offset(
        particle.position.dx + sin(progress * 3 + particle.angle) * 15, // Reduced movement (was *5 and *20)
        particle.position.dy + progress * size.height * particle.speed,
      );

      if (particle.isGlitter) {
        // Draw glitter as a rotating star
        canvas.save();
        canvas.translate(position.dx, position.dy);
        canvas.rotate(progress * 2 * pi); // Reduced rotation speed (was *4)
        
        for (var i = 0; i < 4; i++) {
          canvas.drawLine(
            Offset(-particle.size, 0),
            Offset(particle.size, 0),
            paint,
          );
          canvas.rotate(pi / 4);
        }
        canvas.restore();
      } else {
        // Draw ribbon with wave effect
        canvas.save();
        canvas.translate(position.dx, position.dy);
        canvas.rotate(particle.angle + sin(progress * 2) * pi / 6); // Reduced wave effect (was *3 and pi/4)
        
        final path = Path()
          ..moveTo(-particle.size, -particle.size * 0.3)
          ..quadraticBezierTo(0, 0, particle.size, -particle.size * 0.3)
          ..lineTo(particle.size, particle.size * 0.3)
          ..quadraticBezierTo(0, 0, -particle.size, particle.size * 0.3)
          ..close();
        
        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
