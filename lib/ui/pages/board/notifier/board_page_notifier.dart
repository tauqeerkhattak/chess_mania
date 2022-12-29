import 'dart:ui';

import 'package:chess_mania/models/chess_piece_data.dart';
import 'package:chess_mania/ui/pages/board/notifier/board_page_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardPageNotifier extends StateNotifier<BoardPageState> {
  BoardPageNotifier() : super(LoadingBoardState());
  List<ChessPieceData> pieces = [];

  void addPieces() {
    for (int i = 0; i < 16; i++) {
      if (i < 8) {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'name': 'Diamond',
              'type': 'diamond',
              'x': 0,
              'y': i,
            },
          ),
        );
      } else {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'name': 'Diamond',
              'type': 'square',
              'x': 7,
              'y': 16 - i - 1,
            },
          ),
        );
      }
    }
    state = SuccessBoardState(pieces);
  }

  void updatePieceData({
    required ChessPieceData data,
    required int rIndex,
    required int cIndex,
  }) {
    for (int i = 0; i < pieces.length; i++) {
      if (pieces[i] == data) {
        pieces[i].offset = Offset(
          cIndex.toDouble(),
          rIndex.toDouble(),
        );
        break;
      }
    }
    state = SuccessBoardState(pieces);
  }
}
