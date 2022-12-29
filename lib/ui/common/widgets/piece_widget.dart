import 'package:chess_mania/models/chess_piece_data.dart';
import 'package:chess_mania/ui/common/paint/diamond_painter.dart';
import 'package:chess_mania/ui/common/paint/square_painter.dart';
import 'package:flutter/material.dart';

import '../../../models/piece_type.dart';

class PieceWidget extends StatelessWidget {
  final ChessPieceData pieceData;
  const PieceWidget({
    Key? key,
    required this.pieceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: pieceData,
      delay: const Duration(
        milliseconds: 100,
      ),
      feedback: Opacity(
        opacity: 0.8,
        child: CustomPaint(
          painter: getPainter(),
          child: const SizedBox(
            width: 50,
            height: 50,
          ),
        ),
      ),
      child: CustomPaint(
        painter: getPainter(),
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  CustomPainter getPainter() {
    switch (pieceData.type!) {
      case PieceType.square:
        return SquarePainter();
      case PieceType.diamond:
        return DiamondPainter(
          color: Colors.blue,
        );
      case PieceType.circle:
        return SquarePainter();
    }
  }
}
