import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class UniversitiesScreen extends StatelessWidget {
  const UniversitiesScreen({super.key});

  final List<Map<String, dynamic>> provinces = const [
    {'name': 'Gauteng', 'icon': Icons.location_city, 'unis': '8 Universities', 'color': 0xFFE74C3C},
    {'name': 'Western Cape', 'icon': Icons.beach_access, 'unis': '4 Universities', 'color': 0xFF3498DB},
    {'name': 'KwaZulu-Natal', 'icon': Icons.waves, 'unis': '4 Universities', 'color': 0xFF2ECC71},
    {'name': 'Eastern Cape', 'icon': Icons.landscape, 'unis': '3 Universities', 'color': 0xFFF39C12},
    {'name': 'Free State', 'icon': Icons.grass, 'unis': '2 Universities', 'color': 0xFF9B59B6},
    {'name': 'Limpopo', 'icon': Icons.park, 'unis': '2 Universities', 'color': 0xFF1ABC9C},
    {'name': 'Mpumalanga', 'icon': Icons.terrain, 'unis': '1 University', 'color': 0xFFE67E22},
    {'name': 'North West', 'icon': Icons.sunny, 'unis': '1 University', 'color': 0xFF95A5A6},
    {'name': 'Northern Cape', 'icon': Icons.sunny, 'unis': '1 University', 'color': 0xFFD35400},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('South African Universities'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.primaryOrange,
        elevation: 0,
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
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Find Your University',
                    style: GoogleFonts.ubuntu(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Browse by province',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C3E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search universities...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Province grid
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provinces.length,
                  itemBuilder: (context, index) {
                    final province = provinces[index];
                    return _ProvinceCard(
                      name: province['name'] as String,
                      icon: province['icon'] as IconData,
                      uniCount: province['unis'] as String,
                      color: Color(province['color'] as int),
                      isDark: isDark,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProvinceCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String uniCount;
  final Color color;
  final bool isDark;
  
  const _ProvinceCard({
    required this.name,
    required this.icon,
    required this.uniCount,
    required this.color,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name universities coming soon!'),
            backgroundColor: AppTheme.primaryOrange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
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
                    Colors.white,
                    Colors.grey.shade50,
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              uniCount,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}