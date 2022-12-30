import 'package:flutter/material.dart';

import '../app_colors.dart';

class CurrentTurnWidget extends StatelessWidget {
  const CurrentTurnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blackTile,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
