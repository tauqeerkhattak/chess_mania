import 'package:flutter/material.dart';

class PiecePainter extends CustomPainter {
  Color color;

  PiecePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.width * 0.5),
      20,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
