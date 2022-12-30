import 'dart:math';

import 'package:chess_mania/exceptions/piece_exception.dart';
import 'package:chess_mania/models/chess_piece_data.dart';
import 'package:chess_mania/models/enums/piece_type.dart';
import 'package:chess_mania/ui/pages/board/notifier/board_page_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class BoardPageNotifier extends StateNotifier<BoardPageState> {
  BoardPageNotifier() : super(LoadingBoardState());
  List<ChessPieceData> pieces = [];
  late PieceType currentTurn;

  void addPieces() {
    final random = Random();
    const uuid = Uuid();
    for (int i = 0; i < 32; i++) {
      final id = uuid.v4();
      if (i < 16) {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'id': id,
              'name': 'Diamond',
              'type': 'diamond',
              'x': i > 7 ? 1 : 0,
              'y': i > 7 ? 15 - i : i,
            },
          ),
        );
      } else {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'id': id,
              'name': 'Square',
              'type': 'square',
              'x': i > 23 ? 6 : 7,
              'y': i > 23 ? 32 - i - 1 : 24 - i - 1,
            },
          ),
        );
      }
    }
    currentTurn = PieceType.values[random.nextInt(2)];
    state = SuccessBoardState(pieces);
  }

  void updatePieceData({
    required ChessPieceData data,
    required int rIndex,
    required int cIndex,
    required BuildContext context,
  }) {
    try {
      if (data.type == currentTurn) {
        for (int i = 0; i < pieces.length; i++) {
          if (pieces[i] == data) {
            bool canMove = canPieceMove(data, rIndex, cIndex);
            if (canMove) {
              pieces[i].offset = Offset(
                cIndex.toDouble(),
                rIndex.toDouble(),
              );
              if (currentTurn == PieceType.diamond) {
                currentTurn = PieceType.square;
              } else {
                currentTurn = PieceType.diamond;
              }
            }
            break;
          }
        }
        state = SuccessBoardState(pieces);
      } else {
        throw PieceException('This is not your turn!');
      }
    } on PieceException catch (e) {
      state = ErrorBoardState(e.message, pieces);
    } catch (e) {
      state = ErrorBoardState(e.toString(), pieces);
    }
  }

  bool canPieceMove(ChessPieceData data, int rIndex, int cIndex) {
    bool canMove = true;
    for (final piece in pieces) {
      final dx = piece.offset?.dx ?? 0;
      final dy = piece.offset?.dy ?? 0;
      final pieceDx = data.offset?.dx ?? 0;
      final pieceDy = data.offset?.dy ?? 0;
      if (dx == cIndex && dy == rIndex) {
        throw PieceException('Box is already occupied!');
      } else if (!((pieceDy - 1 == rIndex || pieceDy + 1 == rIndex) &&
          (pieceDx + 1 == cIndex || pieceDx - 1 == cIndex))) {
        throw PieceException('Each piece can only move diagonally!');
      }
    }
    return canMove;
  }
}
