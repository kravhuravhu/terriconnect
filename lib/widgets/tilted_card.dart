import 'package:flutter/material.dart';

class TiltedCard extends StatelessWidget {
  final Widget child;
  final double tiltAngle;
  final Color color;
  final String? badgeText;
  
  const TiltedCard({
    super.key,
    required this.child,
    required this.tiltAngle,
    required this.color,
    this.badgeText,
  });
  
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tiltAngle,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            child,
            if (badgeText != null)
              Positioned(
                top: -12,
                right: -12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6522),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}