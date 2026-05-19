import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/animated_toast.dart';
import '../widgets/animated_card.dart';
import 'results_screen.dart';

class ApsCalculatorScreen extends StatefulWidget {
  const ApsCalculatorScreen({super.key});

  @override
  State<ApsCalculatorScreen> createState() => _ApsCalculatorScreenState();
}

class _ApsCalculatorScreenState extends State<ApsCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  final List<String> subjects = [
    'Home Language',
    'English (First Additional)',
    'Mathematics',
    'Mathematical Literacy',
    'Physical Science',
    'Life Sciences',
    'Accounting',
    'Business Studies',
    'Economics',
    'Geography',
    'History',
    'Life Orientation',
    'Information Technology',
    'Consumer Studies',
    'Dramatic Arts',
    'Visual Arts',
  ];

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  
  // Store marks to pass to results screen
  Map<String, int> _lastMarks = {};

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _animationController.forward();
    
    for (var subject in subjects) {
      _controllers[subject] = TextEditingController();
      _focusNodes[subject] = FocusNode();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  int _calculateAps() {
    int total = 0;
    int subjectsWithMarks = 0;
    
    for (var entry in _controllers.entries) {
      int mark = int.tryParse(entry.value.text) ?? 0;
      if (mark > 0) {
        subjectsWithMarks++;
        if (mark >= 80) {total += 7;}
        else if (mark >= 70) {total += 6;}
        else if (mark >= 60) {total += 5;}
        else if (mark >= 50) {total += 4;}
        else if (mark >= 40) {total += 3;}
        else if (mark >= 30) {total += 2;}
        else if (mark >= 20) {total += 1;}
      }
    }
    
    if (subjectsWithMarks < 6) {
      AnimatedToast.show(
        context: context,
        message: 'Please enter at least 6 subjects',
        icon: Icons.warning,
        backgroundColor: Colors.orange,
      );
      return 0;
    }
    
    return total;
  }
  
  // Get marks map from entered values
  Map<String, int> _getMarksMap() {
    Map<String, int> marks = {};
    for (var entry in _controllers.entries) {
      int mark = int.tryParse(entry.value.text) ?? 0;
      if (mark > 0) {
        marks[entry.key] = mark;
      }
    }
    return marks;
  }

  void _showResults() {
    Haptics.medium();
    int aps = _calculateAps();
    if (aps == 0) return;
    
    _lastMarks = _getMarksMap();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ResultBottomSheet(
        aps: aps,
        onShowMatches: () {
          Navigator.pop(context); // Close bottom sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(studentMarks: _lastMarks),
            ),
          );
        },
      ),
    );
  }

  void _clearAllFields() {
    Haptics.light();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    AnimatedToast.show(
      context: context,
      message: 'All fields cleared',
      icon: Icons.delete_sweep,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('APS Calculator'),
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.primaryOrange,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _clearAllFields,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all',
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1A2E),
                      Color(0xFF16213E),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryOrange,
                      Color(0xFFFF8C42),
                    ],
                  ),
          ),
          child: Column(
            children: [
              // Header with slide animation
              ScaleTransition(
                scale: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calculate_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'APS Calculator',
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your subject marks (0-100)',
                        style: GoogleFonts.ubuntu(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Subject list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return AnimatedCard(
                        onTap: () => _focusNodes[subject]?.requestFocus(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  subject,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _controllers[subject],
                                  focusNode: _focusNodes[subject],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryOrange,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: GoogleFonts.ubuntu(
                                      color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                    ),
                                    filled: true,
                                    fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Calculate button
              Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedCard(
                  onTap: _showResults,
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'CALCULATE APS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
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

// Result Bottom Sheet - Now with "Show Matches" button
class _ResultBottomSheet extends StatelessWidget {
  final int aps;
  final VoidCallback onShowMatches;
  
  const _ResultBottomSheet({
    required this.aps,
    required this.onShowMatches,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String qualification = '';
    String message = '';
    Color color = AppTheme.primaryOrange;
    
    if (aps >= 38) {
      qualification = 'EXCEPTIONAL!';
      message = 'You qualify for top-tier universities and competitive programs.';
      color = const Color(0xFF4CAF50);
    } else if (aps >= 30) {
      qualification = 'GOOD!';
      message = 'You qualify for most degree programs at major universities.';
      color = const Color(0xFF2196F3);
    } else if (aps >= 23) {
      qualification = 'QUALIFIED';
      message = 'You qualify for diploma and higher certificate programs.';
      color = const Color(0xFFFF9800);
    } else if (aps >= 15) {
      qualification = 'ELIGIBLE';
      message = 'You qualify for certificate and bridging courses.';
      color = const Color(0xFFFF5722);
    } else {
      qualification = 'IMPROVE';
      message = 'Consider upgrading your marks or exploring vocational training.';
      color = Colors.red;
    }
    
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Score display
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    'Your APS Score',
                    style: GoogleFonts.ubuntu(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$aps',
                    style: GoogleFonts.ubuntu(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    qualification,
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Haptics.light();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryOrange,
                        side: BorderSide(color: AppTheme.primaryOrange),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.ubuntu(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Haptics.medium();
                        onShowMatches();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'SHOW MATCHES',
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}