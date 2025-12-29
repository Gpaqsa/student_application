import 'package:flutter/material.dart';
import '../models/task.dart';

class GradeCalculator {
  // Calculate module grade from tasks
  static double calculateModuleGrade(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;

    // Filter completed tasks with scores
    final gradedTasks = tasks
        .where((task) =>
            task.isCompleted &&
            task.earnedScore != null &&
            task.maxScore != null &&
            task.weight != null)
        .toList();

    if (gradedTasks.isEmpty) return 0.0;

    double totalGrade = 0.0;
    double totalWeight = 0.0;

    for (var task in gradedTasks) {
      // Calculate percentage for this task
      final percentage = (task.earnedScore! / task.maxScore!) * 100;
      // Add weighted score
      totalGrade += percentage * task.weight!;
      totalWeight += task.weight!;
    }

    // Return weighted average
    return totalWeight > 0 ? totalGrade / totalWeight : 0.0;
  }

  // Get letter grade from percentage
  static String getLetterGrade(double percentage) {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  // Get grade color
  static Color getGradeColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 60) return Colors.deepOrange;
    return Colors.red;
  }
}
