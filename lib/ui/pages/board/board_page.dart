import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/enums/piece_type.dart';
import '../../common/widgets/board_box.dart';
import '../../common/widgets/current_turn_widget.dart';
import '../../common/widgets/piece_widget.dart';
import 'notifier/board_page_notifier.dart';
import 'notifier/board_page_states.dart';

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
      body: Stack(
        children: [
          ..._buildBackground(context),
          _buildBody(),
        ],
      ),
    );
  }

  List<Positioned> _buildBackground(BuildContext context) {
    List<Positioned> dots = [];
    Random random = Random();
    final size = MediaQuery.of(context).size;
    dots = List.generate(
      1300,
      (index) {
        final xPosition = random.nextInt(size.width.toInt());
        final yPosition = random.nextInt(size.height.toInt());
        final r = random.nextInt(255);
        final g = random.nextInt(255);
        final b = random.nextInt(255);
        final color = Color.fromRGBO(r, g, b, 1);
        return Positioned(
          left: xPosition.toDouble(),
          top: yPosition.toDouble(),
          child: Center(
            child: Container(
              height: 5,
              width: 5,
              color: color,
            ),
          ),
        );
      },
    );
    return dots;
  }

  Widget _buildBody() {
    final currentTurn = ref.watch(piecesProvider.notifier).currentTurn;
    print('TURN: ${currentTurn?.name}');
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
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 2.5,
        sigmaY: 2.5,
      ),
      child: SizedBox(
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
          return const SizedBox.shrink();
        }
      },
    );
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
