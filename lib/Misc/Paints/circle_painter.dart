import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a black paint for the background
    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw the black background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), blackPaint);

    // Define the circle's center and radius
    final center = Offset(0, size.height);
    final radius = size.width * 0.8; // Example radius (40% of the width)

    // Create a radial gradient paint for the circle with fading effect
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(255, 255, 52, 86).withOpacity(1.0),
          const Color.fromARGB(255, 255, 52, 86).withOpacity(0.0)
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // Draw the circle with the gradient paint
    canvas.drawCircle(center, radius, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint
  }
}
