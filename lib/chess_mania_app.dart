import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/pages/board/board_page.dart';

class ChessManiaApp extends StatelessWidget {
  const ChessManiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
      home: const ProviderScope(
        child: BoardPage(),
      ),
    );
  }
}
