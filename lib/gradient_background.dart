import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final double overlayOpacity;
  final Color overlayColor;
  const GradientBackground({super.key, required this.child,this.overlayOpacity=.16,this.overlayColor=Colors.black});

 @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Gradient layer
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Overlay layer (doesn't block taps because it's below child)
          IgnorePointer(
            child: Container(color: overlayColor.withValues(alpha:overlayOpacity)),
          ),

          // Your content
          child,
        ],
      ),
    );
  }
}