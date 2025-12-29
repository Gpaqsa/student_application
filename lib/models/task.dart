// lib/models/task.dart
// Data model for assignments, quizzes, and exams
// Tracks completion status and due dates

class Task {
  final String id;
  final String title;
  final String moduleCode;
  final DateTime dueDate;
  final String type;
  final String description;
  bool isCompleted;
  final int priority;
  
  final double? maxScore; // Maximum points (e.g., 100)
  final double? earnedScore; // Points earned (e.g., 85)
  final double? weight; // Percentage weight (e.g., 0.30 for 30%)


  Task({
    required this.id,
    required this.title,
    required this.moduleCode,
    required this.dueDate,
    required this.type,
    this.description = '',
    this.isCompleted = false,
    this.priority = 1,
    this.maxScore,
    this.earnedScore,
    this.weight,
  });

  // Check if task is overdue
  bool get isOverdue {
    return !isCompleted && DateTime.now().isAfter(dueDate);
  }

  // Get days remaining until due date
  int get daysRemaining {
    return dueDate.difference(DateTime.now()).inDays;
  }

  // Factory constructor from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      moduleCode: json['moduleCode'],
      dueDate: DateTime.parse(json['dueDate']),
      type: json['type'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'] ?? 1,
      maxScore: json['maxScore'],
      earnedScore: json['earnedScore'],
      weight: json['weight'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'moduleCode': moduleCode,
      'dueDate': dueDate.toIso8601String(),
      'type': type,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority,
      'maxScore': maxScore,
      'earnedScore': earnedScore,
      'weight': weight,
    };
  }

// Calculate percentage for this task
  double? get percentage {
    if (maxScore != null && earnedScore != null && maxScore! > 0) {
      return (earnedScore! / maxScore!) * 100;
    }
    return null;
  }

  // Copy with method
  Task copyWith({
    String? id,
    String? title,
    String? moduleCode,
    DateTime? dueDate,
    String? type,
    String? description,
    bool? isCompleted,
    int? priority,
    double? maxScore,
    double? earnedScore,
    double? weight,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      moduleCode: moduleCode ?? this.moduleCode,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      maxScore: maxScore ?? this.maxScore,
      earnedScore: earnedScore ?? this.earnedScore,
      weight: weight ?? this.weight,
    );
  }

  
}
