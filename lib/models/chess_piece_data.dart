import 'dart:ui';

import 'package:chess_mania/models/enums/piece_type.dart';
import 'package:equatable/equatable.dart';

class ChessPieceData extends Equatable {
  String? id;
  String? name;
  PieceType? type;
  Offset? offset;

  ChessPieceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'] == null ? null : PieceType.values.byName(json['type']);
    offset = Offset(
      json['x'].toDouble(),
      json['y'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name ?? 'unknown',
      'type': type?.name,
      'x': offset?.dx ?? 0,
      'y': offset?.dy ?? 0,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
      ];
}
