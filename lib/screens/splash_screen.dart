import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/tilted_card.dart';
import 'home_screen.dart';
import '../utils/haptics.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _animationController.forward();
    
    // Navigate to home after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Haptics.success();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 550),
            pageBuilder: (_, animation, __) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF6522),
                    Color(0xFFFF8C42),
                    Color(0xFFFFB27A),
                  ],
                ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              
              // Main content
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.school_rounded,
                                size: 50,
                                color: isDark ? AppTheme.primaryOrange : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32),
                        
                            // Tilted Cards Section
                            SizedBox(
                              height: 200,
                              child: Stack(
                                clipBehavior: Clip.none, 
                                alignment: Alignment.center,
                                children: [
                                  // Back card (tilted left)
                                  Positioned(
                                    left: 90,
                                    top: 20,
                                    child: TiltedCard(
                                      tiltAngle: -0.15,
                                      color: isDark 
                                          ? const Color(0xFF2C2C3E)
                                          : Colors.white.withOpacity(0.95),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.auto_awesome,
                                            size: 32,
                                            color: AppTheme.primaryOrange,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'YOUR\nFUTURE',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Front card (tilted right)
                                  Positioned(
                                    right: 90,
                                    bottom: 20,
                                    child: TiltedCard(
                                      tiltAngle: 0.15,
                                      color: AppTheme.primaryOrange,
                                      badgeText: '✨NEW',
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.celebration,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'ADMITTED!',
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'You qualify!',
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 10,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // App Name
                            Text(
                              'TerriConnect',
                              style: GoogleFonts.ubuntu(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.primaryOrange : Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Connect to Your Future',
                              style: GoogleFonts.ubuntu(
                                fontSize: 14,
                                color: isDark ? Colors.white70 : Colors.white.withOpacity(0.9),
                              ),
                            ),
                            
                            const SizedBox(height: 48),
                            
                            // Loading indicator
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? AppTheme.primaryOrange : Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Text(
                              'Checking your eligibility...',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}