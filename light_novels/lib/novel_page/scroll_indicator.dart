import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height / 20.0,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '繼續閱讀',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .fade(duration: 800.ms, begin: 0.5, end: 0.8)
        .moveY(
          begin: 0,
          end: 5,
          duration: 1.seconds,
          curve: Curves.easeInOut,
        )
        .then()
        .moveY(
          begin: 5,
          end: 0,
          duration: 1.seconds,
          curve: Curves.easeInOut,
        )
        .fade(duration: 800.ms, begin: 0.8, end: 0.5),
      ),
    );
  }
}
