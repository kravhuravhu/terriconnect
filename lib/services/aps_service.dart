class ApsService {
  // Convert mark points
  static int markToPoints(int mark) {
    if (mark >= 80) return 7;
    if (mark >= 70) return 6;
    if (mark >= 60) return 5;
    if (mark >= 50) return 4;
    if (mark >= 40) return 3;
    if (mark >= 30) return 2;
    if (mark >= 20) return 1;
    return 0;
  }
  
  // APS on student marks
  static int calculateAps(Map<String, int> marks, {List<String> exclude = const ['Life Orientation']}) {
    List<int> points = [];
    
    for (var entry in marks.entries) {
      if (!exclude.contains(entry.key)) {
        int pointsFromMark = markToPoints(entry.value);
        if (pointsFromMark > 0) {
          points.add(pointsFromMark);
        }
      }
    }
    
    // Sort descending
    points.sort((a, b) => b.compareTo(a));
    points = points.take(6).toList();
    
    return points.fold(0, (sum, point) => sum + point);
  }
  
  // Calculate APS
  static int calculateUniversityAps(Map<String, int> marks, String universityId) {
    switch (universityId) {
      case 'univen':
        return calculateAps(marks);
      case 'ul':
        return calculateAps(marks);
      default:
        return calculateAps(marks);
    }
  }
}