import 'aps_service.dart';

class CourseMatch {
  final String universityId;
  final String universityName;
  final String courseId;
  final String courseName;
  final String facultyId;
  final String qualification;
  final int duration;
  final int minAps;
  final int studentAps;
  final bool meetsAps;
  final List<Map<String, dynamic>> metRequirements;
  final List<Map<String, dynamic>> missingRequirements;
  final int matchPercentage;
  
  CourseMatch({
    required this.universityId,
    required this.universityName,
    required this.courseId,
    required this.courseName,
    required this.facultyId,
    required this.qualification,
    required this.duration,
    required this.minAps,
    required this.studentAps,
    required this.meetsAps,
    required this.metRequirements,
    required this.missingRequirements,
    required this.matchPercentage,
  });
  
  bool get qualifies => meetsAps && missingRequirements.isEmpty;
}

class MatcherService {
  // Check if student meets subject requirements
  static List<Map<String, dynamic>> checkSubjectRequirements(
    Map<String, int> marks,
    Map<String, dynamic>? requirements,
  ) {
    List<Map<String, dynamic>> missing = [];
    
    // If no requirements, return empty (no missing requirements)
    if (requirements == null) return missing;
    
    // Check compulsory subjects
    if (requirements.containsKey('subjects')) {
      final subjects = requirements['subjects'];
      if (subjects is List) {
        for (var req in subjects) {
          String subjectName = req['name'];
          int minMark = req['minMark'];
          int studentMark = marks[subjectName] ?? 0;
          
          if (studentMark < minMark) {
            missing.add({
              'subject': subjectName,
              'studentMark': studentMark,
              'requiredMark': minMark,
              'status': 'missing',
            });
          }
        }
      }
    }
    
    // Check math requirement
    if (requirements.containsKey('mathRequirement')) {
      final mathReq = requirements['mathRequirement'];
      if (mathReq.containsKey('anyOf')) {
        final options = mathReq['anyOf'] as List;
        bool met = false;
        for (var option in options) {
          int studentMark = marks[option['name']] ?? 0;
          if (studentMark >= option['minMark']) {
            met = true;
            break;
          }
        }
        if (!met) {
          missing.add({
            'subject': 'Mathematics',
            'requiredMark': mathReq['anyOf'][0]['minMark'],
            'status': 'missing',
          });
        }
      }
    }
    
    // Check "anyOf" requirements
    if (requirements.containsKey('anyOf')) {
      final anyOf = requirements['anyOf'] as List;
      bool met = false;
      for (var option in anyOf) {
        int studentMark = marks[option['name']] ?? 0;
        if (studentMark >= option['minMark']) {
          met = true;
          break;
        }
      }
      if (!met && anyOf.isNotEmpty) {
        missing.add({
          'subject': 'Any of: ${anyOf.map((o) => o['name']).join(', ')}',
          'requiredMark': anyOf[0]['minMark'],
          'status': 'missing',
        });
      }
    }
    
    return missing;
  }
  
  // Match student with all courses
  static Future<List<CourseMatch>> matchCourses(
    Map<String, int> marks,
    List<Map<String, dynamic>> allCourses,
  ) async {
    List<CourseMatch> matches = [];
    int studentAps = ApsService.calculateAps(marks);
    
    for (var course in allCourses) {
      // Safely get values with defaults
      int minAps = course['minAps'] ?? 999; // If no APS specified, very high requirement
      bool meetsAps = studentAps >= minAps;
      
      Map<String, dynamic> requirements = course['requirements'] ?? {};
      List<Map<String, dynamic>> missingReqs = checkSubjectRequirements(marks, requirements);
      
      // Calculate match percentage
      int matchPercentage = 0;
      if (minAps > 0 && minAps < 999) {
        double apsRatio = studentAps / minAps;
        matchPercentage = (apsRatio * 100).toInt().clamp(0, 100);
      } else if (minAps == 999) {
        // No APS requirement specified, assume it's always a match
        matchPercentage = 100;
      }
      
      // Adjust percentage based on missing requirements
      if (missingReqs.isNotEmpty) {
        matchPercentage = (matchPercentage * 0.7).toInt();
      }
      
      matches.add(CourseMatch(
        universityId: course['universityId'] ?? 'unknown',
        universityName: course['universityName'] ?? 'Unknown University',
        courseId: course['id'] ?? 'unknown',
        courseName: course['name'] ?? 'Unknown Course',
        facultyId: course['facultyId'] ?? 'unknown',
        qualification: course['qualification'] ?? 'Degree',
        duration: course['duration'] ?? 3,
        minAps: minAps == 999 ? 0 : minAps,
        studentAps: studentAps,
        meetsAps: meetsAps,
        metRequirements: [],
        missingRequirements: missingReqs,
        matchPercentage: matchPercentage,
      ));
    }
    
    // Sort by match percentage (highest first)
    matches.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
    
    return matches;
  }
}