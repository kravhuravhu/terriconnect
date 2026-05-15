import 'package:flutter/material.dart';

class Animations {
  // Fade transition
  static Route<T> fadeTransition<T>(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeIn),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
  
  // Slide from bottom transition
  static Route<T> slideUpTransition<T>(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
  
  // Scale transition (zoom in)
  static Route<T> scaleTransition<T>(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
  
  // Rotate + scale (special for achievements)
  static Route<T> celebrateTransition<T>(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: RotationTransition(
            turns: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
}

// Shimmer effect for loading skeletons
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  
  const ShimmerLoading({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      period: const Duration(milliseconds: 1500),
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade300,
          Colors.grey.shade100,
          Colors.grey.shade300,
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment(-1.0, 0.0),
        end: Alignment(1.0, 0.0),
      ),
      child: child,
    );
  }
}

// Simple shimmer widget (custom implementation without external package)
class Shimmer extends StatefulWidget {
  final Duration period;
  final Gradient gradient;
  final Widget child;
  
  const Shimmer({
    super.key,
    required this.period,
    required this.gradient,
    required this.child,
  });
  
  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period);
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
    _controller.repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return widget.gradient.createShader(
              Rect.fromLTRB(
                bounds.width * _animation.value - bounds.width,
                0,
                bounds.width * _animation.value,
                bounds.height,
              ),
            );
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}