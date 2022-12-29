import 'dart:ui';

import 'package:chess_mania/models/chess_piece_data.dart';
import 'package:chess_mania/ui/pages/board/notifier/board_page_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class BoardPageNotifier extends StateNotifier<BoardPageState> {
  BoardPageNotifier() : super(LoadingBoardState());
  List<ChessPieceData> pieces = [];

  void addPieces() {
    const uuid = Uuid();
    for (int i = 0; i < 16; i++) {
      final id = uuid.v4();
      if (i < 8) {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'id': id,
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
              'id': id,
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
    required BuildContext context,
  }) {
    for (int i = 0; i < pieces.length; i++) {
      if (pieces[i] == data) {
        bool canMove = true;
        for (final data in pieces) {
          if (data.offset?.dx == cIndex && data.offset?.dy == rIndex) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          pieces[i].offset = Offset(
            cIndex.toDouble(),
            rIndex.toDouble(),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Box is already occupied!'),
            ),
          );
        }
        break;
      }
    }
    state = SuccessBoardState(pieces);
  }
}
