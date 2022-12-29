import 'package:chess_mania/models/chess_piece_data.dart';
import 'package:chess_mania/ui/pages/board/board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constants.dart';
import '../app_colors.dart';

class BoardBox extends ConsumerWidget {
  final int rIndex, cIndex;
  final Widget? child;
  const BoardBox({
    Key? key,
    required this.rIndex,
    required this.cIndex,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<ChessPieceData>(
      builder: (context, items, builder) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: rIndex % 2 == 0
                    ? cIndex % 2 == 0
                        ? AppColors.whiteTile
                        : AppColors.blackTile
                    : cIndex % 2 == 0
                        ? AppColors.blackTile
                        : AppColors.whiteTile,
              ),
              child: Center(
                child: child,
              ),
            ),
            if (rIndex == 0)
              Positioned(
                left: 5,
                top: 5,
                child: Text(
                  '${8 - (cIndex)}',
                  style: TextStyle(
                    color: cIndex % 2 == 0
                        ? AppColors.blackTile
                        : AppColors.whiteTile,
                  ),
                ),
              ),
            if (cIndex == 7)
              Positioned(
                right: 5,
                bottom: 5,
                child: Text(
                  letters[rIndex],
                  style: TextStyle(
                    color: rIndex % 2 == 0
                        ? AppColors.whiteTile
                        : AppColors.blackTile,
                  ),
                ),
              ),
          ],
        );
      },
      onAccept: (data) {
        ref.read(piecesProvider.notifier).updatePieceData(
              data: data,
              rIndex: rIndex,
              cIndex: cIndex,
            );
      },
    );
  }
}
