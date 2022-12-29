import 'package:chess_mania/models/chess_piece_data.dart';

abstract class BoardPageState {}

class LoadingBoardState extends BoardPageState {}

class SuccessBoardState extends BoardPageState {
  List<ChessPieceData> pieces;

  SuccessBoardState(this.pieces);
}

class ErrorBoardState extends BoardPageState {}
