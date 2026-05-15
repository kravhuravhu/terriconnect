import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StaggeredList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration itemAnimationDuration;
  final Duration animationDuration;
  
  const StaggeredList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemAnimationDuration = const Duration(milliseconds: 200),
    this.animationDuration = const Duration(milliseconds: 800),
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: animationDuration,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: itemBuilder(context, index),
              ),
            ),
          );
        },
      ),
    );
  }
}