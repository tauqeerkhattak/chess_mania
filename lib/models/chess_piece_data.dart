import 'dart:ui';

import 'package:chess_mania/models/piece_type.dart';
import 'package:equatable/equatable.dart';

class ChessPieceData extends Equatable {
  String? name;
  PieceType? type;
  Offset? offset;

  ChessPieceData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'] == null ? null : PieceType.values.byName(json['type']);
    offset = Offset(json['x'], json['y']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name ?? 'unknown',
      'type': type?.name,
      'x': offset?.dx ?? 0,
      'y': offset?.dy ?? 0,
    };
  }

  @override
  List<Object?> get props => [
        name,
        type,
        offset?.dx,
        offset?.dy,
      ];
}
