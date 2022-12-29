import 'package:flutter/material.dart';

class DiamondPainter extends CustomPainter {
  final Color color;
  DiamondPainter({
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    Path path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.9, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.9);
    path.lineTo(size.width * 0.1, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
