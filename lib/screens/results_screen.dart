import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/matcher_service.dart';
import '../services/data_service.dart';
import '../utils/haptics.dart';

class ResultsScreen extends StatefulWidget {
  final Map<String, int> studentMarks;
  
  const ResultsScreen({super.key, required this.studentMarks});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<CourseMatch> _matches = [];
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadMatches();
  }
  
  Future<void> _loadMatches() async {
    try {
      final dataService = DataService();
      final allCourses = await dataService.loadAllCourses();
      final matches = await MatcherService.matchCourses(widget.studentMarks, allCourses);
      
      setState(() {
        _matches = matches.where((m) => m.matchPercentage > 30).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Matches'),
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
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryOrange, Color(0xFFFF8C42)],
                ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading results',
                          style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : _matches.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sentiment_dissatisfied, size: 64, color: Colors.white),
                            const SizedBox(height: 16),
                            Text(
                              'No matches found',
                              style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try improving your marks or check other universities',
                              style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _matches.length,
                        itemBuilder: (context, index) {
                          final match = _matches[index];
                          return _MatchCard(match: match, isDark: isDark);
                        },
                      ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final CourseMatch match;
  final bool isDark;
  
  const _MatchCard({required this.match, required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    final bool qualifies = match.qualifies;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: qualifies ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with qualification badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: qualifies ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.courseName,
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.universityName,
                        style: GoogleFonts.ubuntu(
                          fontSize: 13,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: qualifies ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    qualifies ? 'QUALIFIES' : 'BORDERLINE',
                    style: GoogleFonts.ubuntu(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoChip(Icons.bolt, 'APS ${match.studentAps} / ${match.minAps}'),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.school, match.qualification),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.timer, '${match.duration} years'),
                  ],
                ),
                const SizedBox(height: 12),
                if (match.missingRequirements.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Requirements to improve:',
                    style: GoogleFonts.ubuntu(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...match.missingRequirements.map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, size: 14, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            req['subject'],
                            style: GoogleFonts.ubuntu(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
                          ),
                        ),
                        Text(
                          'Need ${req['requiredMark']}%',
                          style: GoogleFonts.ubuntu(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.orange),
                        ),
                      ],
                    ),
                  )),
                ],
                
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: match.matchPercentage / 100,
                  backgroundColor: Colors.grey.shade300,
                  color: match.matchPercentage >= 80 ? Colors.green : (match.matchPercentage >= 60 ? AppTheme.primaryOrange : Colors.orange),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${match.matchPercentage}% match',
                  style: GoogleFonts.ubuntu(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? Colors.white54 : Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.ubuntu(
              fontSize: 10,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}