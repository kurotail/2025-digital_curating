import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final iconLength = MediaQuery.sizeOf(context).shortestSide / 3.0;
    return Center(
      child: SizedBox(
        width: iconLength,
        height: iconLength,
        child: Image.network(
              "loading_icon.png",
              width: iconLength,
              height: iconLength,
              fit: BoxFit.contain,
            )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 4.seconds),
      ),
    );
  }
}
