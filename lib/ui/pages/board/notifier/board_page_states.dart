import '../../../../models/chess_piece_data.dart';

abstract class BoardPageState {
  List<ChessPieceData> pieces;
  BoardPageState(this.pieces);
}

class LoadingBoardState extends BoardPageState {
  LoadingBoardState() : super([]);
}

class SuccessBoardState extends BoardPageState {
  SuccessBoardState(super.pieces);
}

class ErrorBoardState extends BoardPageState {
  String errorMessage;

  ErrorBoardState(this.errorMessage, super.pieces);
}
