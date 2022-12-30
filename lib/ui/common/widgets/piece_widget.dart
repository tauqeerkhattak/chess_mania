import 'package:chess_mania/models/chess_piece_data.dart';
import 'package:chess_mania/ui/common/paint/piece_painter.dart';
import 'package:flutter/material.dart';

import '../../../models/enums/piece_type.dart';

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
        milliseconds: 150,
      ),
      feedback: Opacity(
        opacity: 0.8,
        child: CustomPaint(
          painter: getPainter(),
          child: SizedBox(
            width: 60,
            height: 60,
            child: _buildCenterSpace(),
          ),
        ),
      ),
      child: CustomPaint(
        painter: getPainter(),
        child: SizedBox(
          width: 60,
          height: 60,
          child: _buildCenterSpace(),
        ),
      ),
    );
  }

  CustomPainter getPainter() {
    switch (pieceData.type!) {
      case PieceType.red:
        return PiecePainter(
          color: Colors.red,
        );
      case PieceType.blue:
        return PiecePainter(
          color: Colors.blue,
        );
    }
  }

  Widget _buildCenterSpace() {
    return Center(
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
