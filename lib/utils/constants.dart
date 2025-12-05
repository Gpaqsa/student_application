// lib/utils/constants.dart
// Application-wide constants and configuration values
// Centralizes all magic numbers and strings

class AppConstants {
  // App information
  static const String appName = 'ScholarSync';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double cardRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonRadius = 8.0;
  static const double iconSize = 24.0;
  
  // Padding and margins
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Task types
  static const String typeAssignment = 'Assignment';
  static const String typeQuiz = 'Quiz';
  static const String typeExam = 'Exam';
  static const String typeProject = 'Project';
  
  // Material types
  static const String materialPDF = 'PDF';
  static const String materialVideo = 'Video';
  static const String materialSlides = 'Slides';
  static const String materialDocument = 'Document';
  
  // Date formats
  static const String dateFormatFull = 'EEEE, MMMM d, yyyy';
  static const String dateFormatShort = 'MMM d, yyyy';
  static const String dateFormatMonth = 'MMMM yyyy';
  static const String timeFormat = 'h:mm a';
}