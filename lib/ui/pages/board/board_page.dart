import 'package:chess_mania/ui/pages/board/notifier/board_page_notifier.dart';
import 'package:chess_mania/ui/pages/board/notifier/board_page_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/board_box.dart';
import '../../common/widgets/piece_widget.dart';

final piecesProvider =
    StateNotifierProvider.autoDispose<BoardPageNotifier, BoardPageState>(
  (ref) => BoardPageNotifier(),
);

class BoardPage extends ConsumerStatefulWidget {
  const BoardPage({super.key});

  @override
  ConsumerState<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends ConsumerState<BoardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(piecesProvider.notifier).addPieces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.height * 0.6,
              child: _buildBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Column(
      children: List.generate(
        8,
        (cIndex) {
          return _buildColumn(cIndex);
        },
      ),
    );
  }

  Widget _buildColumn(int cIndex) {
    return Expanded(
      child: Row(
        children: List.generate(
          8,
          (rIndex) {
            return Expanded(
              child: BoardBox(
                cIndex: cIndex,
                rIndex: rIndex,
                child: _getPiece(
                  cIndex,
                  rIndex,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget? _getPiece(int dx, int dy) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(piecesProvider);
        if (state is SuccessBoardState) {
          final pieces = state.pieces.where((element) {
            return element.offset!.dx.toInt() == dx &&
                element.offset!.dy.toInt() == dy;
          }).toList();
          if (pieces.isNotEmpty) {
            return PieceWidget(
              pieceData: pieces.first,
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
