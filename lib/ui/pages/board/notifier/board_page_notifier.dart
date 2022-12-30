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
  List<int> odds = [7, 5, 3, 1];
  List<int> evens = [0, 2, 4, 6];
  PieceType? currentTurn;

  void addPieces() {
    final random = Random();
    currentTurn = PieceType.values[random.nextInt(2)];
    const uuid = Uuid();
    for (int i = 0; i < 24; i++) {
      final id = uuid.v4();
      if (i < 12) {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'id': id,
              'name': 'Diamond',
              'type': PieceType.blue.name,
              'x': i > 3
                  ? i > 7
                      ? 2
                      : 1
                  : 0,
              'y': i > 3
                  ? i > 7
                      ? odds[11 - i]
                      : evens[7 - i]
                  : odds[3 - i],
            },
          ),
        );
      } else {
        pieces.add(
          ChessPieceData.fromJson(
            {
              'id': id,
              'name': 'Square',
              'type': PieceType.red.name,
              'x': i > 15
                  ? i > 19
                      ? 6
                      : 5
                  : 7,
              'y': i > 15
                  ? i > 19
                      ? odds[23 - i]
                      : evens[19 - i]
                  : evens[15 - i],
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
              if (currentTurn == PieceType.blue) {
                currentTurn = PieceType.red;
              } else {
                currentTurn = PieceType.blue;
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
