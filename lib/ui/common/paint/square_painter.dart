import 'package:flutter/material.dart';

class SquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1.2;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          size.width * 0.5,
          size.height * 0.5,
        ),
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
