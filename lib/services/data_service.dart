import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  // Load all universities master list
  Future<List<Map<String, dynamic>>> loadUniversities() async {
    final String jsonString = await rootBundle.loadString('assets/data/universities.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(data['universities']);
  }
  
  // Load specific university data
  Future<Map<String, dynamic>> loadUniversity(String universityId) async {
    final String infoString = await rootBundle.loadString('assets/data/$universityId/info.json');
    final String facultiesString = await rootBundle.loadString('assets/data/$universityId/faculties.json');
    final String coursesString = await rootBundle.loadString('assets/data/$universityId/courses.json');
    
    final Map<String, dynamic> coursesData = json.decode(coursesString);
    
    return {
      'info': json.decode(infoString),
      'faculties': json.decode(facultiesString),
      'courses': coursesData['courses'], // Get the courses array from the object
    };
  }
  
  // Load all courses from all universities (for matching)
  Future<List<Map<String, dynamic>>> loadAllCourses() async {
    List<Map<String, dynamic>> allCourses = [];
    
    final universities = await loadUniversities();
    for (var uni in universities) {
      try {
        final uniData = await loadUniversity(uni['id']);
        final courses = uniData['courses'];
        
        if (courses is List) {
          for (var course in courses) {
            course['universityId'] = uni['id'];
            course['universityName'] = uni['name'];
            allCourses.add(course);
          }
        }
      } catch (e) {
        print('Error loading ${uni['id']}: $e');
      }
    }
    
    print('Loaded ${allCourses.length} courses'); // Debug print
    return allCourses;
  }
}