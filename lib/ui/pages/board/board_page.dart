import 'dart:async';
import 'dart:math';

import 'package:chess_mania/models/enums/piece_type.dart';
import 'package:chess_mania/ui/common/widgets/current_turn_widget.dart';
import 'package:chess_mania/ui/pages/board/notifier/board_page_notifier.dart';
import 'package:chess_mania/ui/pages/board/notifier/board_page_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/app_colors.dart';
import '../../common/widgets/board_box.dart';
import '../../common/widgets/piece_widget.dart';

final piecesProvider =
    StateNotifierProvider.autoDispose<BoardPageNotifier, BoardPageState>(
  (ref) => BoardPageNotifier(),
);

final gradientProvider = StateProvider.autoDispose<Color>(
  (ref) => AppColors.gradients.first,
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
      Timer.periodic(const Duration(seconds: 3), (timer) {
        final random = Random();
        final index = random.nextInt(4);
        print('INDEX: $index');
        ref.read(gradientProvider.notifier).state = AppColors.gradients[index];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final change = ref.watch(gradientProvider);
    print('CHANGED: ${change}');
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 2000,
      ),
      color: change,
    );
  }

  Widget _buildBody() {
    final currentTurn = ref.read(piecesProvider.notifier).currentTurn;
    ref.listen(piecesProvider, (previous, next) {
      if (next is ErrorBoardState) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage,
            ),
          ),
        );
      }
    });
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentTurn != null)
            _buildTurnWidget(
              PieceType.blue,
              currentTurn,
            ),
          SizedBox(
            height: !kIsWeb
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height * 0.6,
            width: !kIsWeb
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height * 0.6,
            child: _buildBoard(),
          ),
          if (currentTurn != null)
            _buildTurnWidget(
              PieceType.red,
              currentTurn,
            ),
        ],
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
    final state = ref.watch(piecesProvider);
    if (state is SuccessBoardState || state is ErrorBoardState) {
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
      return null;
    }
  }

  Widget _buildTurnWidget(PieceType type, PieceType turn) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (turn == type) const CurrentTurnWidget(),
          const SizedBox(
            width: 30,
          ),
          Text(
            'Player ${type.name[0].toUpperCase()}${type.name.replaceRange(0, 1, '')}',
            style: TextStyle(
              color: PieceType.blue == type ? Colors.blue : Colors.red,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}
