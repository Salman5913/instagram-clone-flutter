import 'dart:convert';

import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child; //child widget to required by LikeAnimation widget
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd; //optional call back function
  final bool smallLike;
  const LikeAnimation(
      {super.key,
      required this.child,
      required this.isAnimating,
      this.onEnd,
      required this.smallLike,
      this.duration = const Duration(milliseconds: 150)});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller; //to controll animation
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: 150)); //initializing animation controller
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
