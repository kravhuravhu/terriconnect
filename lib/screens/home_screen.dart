import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import 'aps_calculator_screen.dart';
import 'universities_screen.dart';
import '../utils/animations.dart';
import '../utils/haptics.dart';
import '../widgets/animated_card.dart';
import '../widgets/animated_toast.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: GoogleFonts.ubuntu(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            'Future Graduate',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Stats cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildStatCard(
                      'Your APS',
                      '--',
                      Icons.calculate_outlined,
                      context,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      'Universities',
                      '26',
                      Icons.school_outlined,
                      context,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      'Courses',
                      '500+',
                      Icons.book_outlined,
                      context,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Menu Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    children: [
                      _MenuCard(
                        icon: Icons.calculate_outlined,
                        title: 'APS\nCalculator',
                        subtitle: 'Calculate your score',
                        onTap: () {
                          Haptics.medium(); 
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ApsCalculatorScreen()),
                          );
                        },
                      ),
                      _MenuCard(
                        icon: Icons.school_outlined,
                        title: 'Universities',
                        subtitle: 'Browse by province',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UniversitiesScreen()),
                          );
                        },
                      ),
                      _MenuCard(
                        icon: Icons.insights_outlined,
                        title: 'My Results',
                        subtitle: 'Track progress',
                        onTap: () {
                          _showComingSoonSnackbar(context);
                        },
                      ),
                      _MenuCard(
                        icon: Icons.book_outlined,
                        title: 'Courses',
                        subtitle: 'Find matches',
                        onTap: () {
                          _showComingSoonSnackbar(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Footer
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark 
                      ? const Color(0xFF1E1E2E).withOpacity(0.9)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Footer links row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FooterLink(
                          icon: Icons.info_outline,
                          label: 'About',
                          onTap: () => _showBlurredDialog(
                            context, 
                            _buildAboutContent(context),
                            'About TerriConnect',
                          ),
                        ),
                        _FooterLink(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy',
                          onTap: () => _showBlurredDialog(
                            context, 
                            _buildPrivacyContent(context),
                            'Privacy Policy',
                          ),
                        ),
                        _FooterLink(
                          icon: Icons.contact_support_outlined,
                          label: 'Support',
                          onTap: () => _showBlurredDialog(
                            context, 
                            _buildSupportContent(context),
                            'Support',
                          ),
                        ),
                        _FooterLink(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          onTap: () => _showBlurredDialog(
                            context, 
                            _buildShareContent(context),
                            'Share TerriConnect',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Copyright text
                    Text(
                      '© 2026 TerriConnect | Connect to Your Future',
                      style: GoogleFonts.ubuntu(
                        fontSize: 10,
                        color: isDark ? Colors.white38 : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Empowering South African students',
                      style: GoogleFonts.ubuntu(
                        fontSize: 9,
                        color: isDark ? Colors.white24 : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.ubuntu(
                fontSize: 11,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        backgroundColor: AppTheme.primaryOrange,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  // ============= BLUR DIALOG METHOD =============
  void _showBlurredDialog(BuildContext context, Widget content, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Darker barrier
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            // Glassmorphic blurred effect
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark 
                    ? const Color(0xFF1E1E2E).withOpacity(0.95)
                    : Colors.white.withOpacity(0.95),
                isDark 
                    ? const Color(0xFF2C2C3E).withOpacity(0.95)
                    : Colors.white.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : AppTheme.primaryOrange.withOpacity(0.2),
              width: 1,
            ),
            // Backdrop blur effect
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark 
                          ? const Color(0xFF1E1E2E).withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                      isDark 
                          ? const Color(0xFF2C2C3E).withOpacity(0.7)
                          : Colors.white.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Divider
                    Container(
                      width: 50,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Content
                    content,
                    const SizedBox(height: 24),
                    // Close button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // ============= DIALOG CONTENT BUILDERS =============
  
  Widget _buildAboutContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.school_rounded,
            size: 35,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Version 2.0.0',
          style: GoogleFonts.ubuntu(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'TerriConnect helps South African students find their perfect university match. Calculate your APS, browse universities by province, and discover courses that match your dreams.',
          textAlign: TextAlign.center,
          style: GoogleFonts.ubuntu(
            fontSize: 14,
            height: 1.4,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, size: 14, color: AppTheme.primaryOrange),
            const SizedBox(width: 4),
            Text(
              'Made in South Africa',
              style: GoogleFonts.ubuntu(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPrivacyContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_rounded,
            size: 35,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 16),
        _buildPrivacyItem(
          Icons.devices,
          'Local Storage',
          'Your data stays on your device',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildPrivacyItem(
          Icons.visibility_off,
          'No Tracking',
          'We never collect personal information',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildPrivacyItem(
          Icons.cloud_off,
          'Offline First',
          'Works without internet connection',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildPrivacyItem(
          Icons.school,
          'Public Data',
          'University info from official prospectuses',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildPrivacyItem(
          Icons.favorite,
          '100% Free',
          'No hidden costs, ever',
          isDark,
        ),
      ],
    );
  }
  
  Widget _buildPrivacyItem(IconData icon, String title, String subtitle, bool isDark) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryOrange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.ubuntu(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSupportContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.support_agent,
            size: 35,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 16),
        _buildSupportItem(
          Icons.email,
          'Email Support',
          'info@arrithnius.co.za',
          '24-48 hour response',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildSupportItem(
          Icons.language,
          'Website',
          'www.arrithnius.co.za',
          'Updates and resources',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildSupportItem(
          Icons.bug_report,
          'Report Issue',
          'Found a bug? Let us know',
          'Help us improve',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildSupportItem(
          Icons.feedback,
          'Feedback',
          'We love hearing from you',
          'Suggest features',
          isDark,
        ),
      ],
    );
  }
  
  Widget _buildSupportItem(IconData icon, String title, String value, String subtitle, bool isDark) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryOrange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.ubuntu(
                  fontSize: 13,
                  color: AppTheme.primaryOrange,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.ubuntu(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildShareContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.share,
            size: 35,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Help other students discover their future!',
          textAlign: TextAlign.center,
          style: GoogleFonts.ubuntu(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildShareOption(FontAwesomeIcons.whatsapp, 'WhatsApp', const Color(0xFF25D366)),
            _buildShareOption(FontAwesomeIcons.linkedin, 'Linkedin', const Color(0xFF1877F2)),
            _buildShareOption(Icons.email, 'Email', const Color(0xFFD44638)),
            _buildShareOption(FontAwesomeIcons.copy, 'Copy Link', AppTheme.primaryOrange),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Coming soon!',
          style: GoogleFonts.ubuntu(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
      ],
    );
  }
  
  Widget _buildShareOption(IconData icon, String label, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Share functionality coming soon
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.ubuntu(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF2C2C3E),
                    const Color(0xFF1E1E2E),
                  ]
                : [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.85),
                  ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isDark ? AppTheme.primaryOrange : AppTheme.primaryOrange,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _FooterLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.white60 : Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.ubuntu(
              fontSize: 11,
              color: isDark ? Colors.white60 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}