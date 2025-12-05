// lib/providers/app_data.dart
// Central state management using Provider pattern
// Manages all app data and notifies listeners of changes

import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/task.dart';
import '../models/study_material.dart';
import '../models/calendar_event.dart';
import '../utils/colors.dart';

class AppData extends ChangeNotifier {
  // Sample data - in production, this would come from an API or local database
  final List<Module> _modules = [
    Module(
      id: '1',
      name: 'Data Structures & Algorithms',
      code: 'CS301',
      instructor: 'Dr. Emily Smith',
      grade: 85.5,
      color: AppColors.primary,
      description: 'Advanced data structures and algorithm design',
      syllabus: [
        'Introduction to Data Structures',
        'Arrays and Linked Lists',
        'Stacks and Queues',
        'Trees and Graphs',
        'Sorting and Searching Algorithms',
        'Dynamic Programming',
      ],
    ),
    Module(
      id: '2',
      name: 'Mobile Application Development',
      code: 'CS402',
      instructor: 'Prof. Michael Johnson',
      grade: 92.0,
      color: AppColors.success,
      description: 'Cross-platform mobile app development with Flutter',
      syllabus: [
        'Introduction to Mobile Development',
        'Flutter Framework Basics',
        'State Management',
        'Navigation and Routing',
        'API Integration',
        'Deployment and Publishing',
      ],
    ),
    Module(
      id: '3',
      name: 'Database Management Systems',
      code: 'CS303',
      instructor: 'Dr. Sarah Williams',
      grade: 78.5,
      color: AppColors.warning,
      description: 'Relational databases and SQL fundamentals',
      syllabus: [
        'Database Concepts',
        'SQL Fundamentals',
        'Database Design',
        'Normalization',
        'Transactions and Concurrency',
        'NoSQL Databases',
      ],
    ),
    Module(
      id: '4',
      name: 'Software Engineering',
      code: 'CS404',
      instructor: 'Prof. David Brown',
      grade: 88.0,
      color: Colors.purple,
      description: 'Software development lifecycle and best practices',
      syllabus: [
        'SDLC Models',
        'Requirements Engineering',
        'Design Patterns',
        'Testing Strategies',
        'Project Management',
        'DevOps Practices',
      ],
    ),
  ];

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Assignment 1: Binary Trees Implementation',
      moduleCode: 'CS301',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      type: 'Assignment',
      description:
          'Implement binary search tree with insert, delete, and search operations',
      priority: 3,
    ),
    Task(
      id: '2',
      title: 'Quiz 2: Flutter State Management',
      moduleCode: 'CS402',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      type: 'Quiz',
      description: 'Online quiz covering Provider, Bloc, and GetX',
      priority: 2,
    ),
    Task(
      id: '3',
      title: 'Project: Library Management System',
      moduleCode: 'CS303',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      type: 'Project',
      description: 'Design and implement a complete database system',
      priority: 3,
    ),
    Task(
      id: '4',
      title: 'Midterm Exam Preparation',
      moduleCode: 'CS301',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      type: 'Exam',
      description: 'Review chapters 1-6 for midterm examination',
      priority: 3,
    ),
    Task(
      id: '5',
      title: 'Assignment 2: Database Normalization',
      moduleCode: 'CS303',
      dueDate: DateTime.now().add(const Duration(days: 4)),
      type: 'Assignment',
      description: 'Normalize given database schema to 3NF',
      priority: 2,
    ),
    Task(
      id: '6',
      title: 'Group Project: Agile Sprint Planning',
      moduleCode: 'CS404',
      dueDate: DateTime.now().add(const Duration(days: 6)),
      type: 'Project',
      description: 'Complete sprint planning for team project',
      priority: 2,
    ),
  ];

  final List<StudyMaterial> _materials = [
    StudyMaterial(
      id: '1',
      title: 'Lecture 5: Sorting Algorithms',
      type: 'PDF',
      moduleCode: 'CS301',
      uploadDate: DateTime.now().subtract(const Duration(days: 2)),
      sizeInBytes: 2048576,
      uploadedBy: 'Dr. Emily Smith',
    ),
    StudyMaterial(
      id: '2',
      title: 'Flutter State Management Tutorial',
      type: 'Video',
      moduleCode: 'CS402',
      uploadDate: DateTime.now().subtract(const Duration(days: 1)),
      sizeInBytes: 52428800,
      uploadedBy: 'Prof. Michael Johnson',
    ),
    StudyMaterial(
      id: '3',
      title: 'SQL Query Examples',
      type: 'PDF',
      moduleCode: 'CS303',
      uploadDate: DateTime.now().subtract(const Duration(days: 3)),
      sizeInBytes: 1048576,
      uploadedBy: 'Dr. Sarah Williams',
    ),
    StudyMaterial(
      id: '4',
      title: 'Design Patterns Presentation',
      type: 'Slides',
      moduleCode: 'CS404',
      uploadDate: DateTime.now().subtract(const Duration(days: 4)),
      sizeInBytes: 3145728,
      uploadedBy: 'Prof. David Brown',
    ),
  ];

  // Getters
  List<Module> get modules => _modules;
  List<Task> get tasks => _tasks;
  List<StudyMaterial> get materials => _materials;

  // Get calendar events from tasks
  List<CalendarEvent> get calendarEvents {
    return _tasks
        .map((task) => CalendarEvent(
              id: task.id,
              title: task.title,
              date: task.dueDate,
              type: task.type,
              moduleCode: task.moduleCode,
              description: task.description,
            ))
        .toList();
  }

  // Get pending tasks count
  int get pendingTasksCount {
    return _tasks.where((task) => !task.isCompleted).length;
  }

  // Get overdue tasks count
  int get overdueTasksCount {
    return _tasks.where((task) => task.isOverdue).length;
  }

  // Get upcoming tasks (next 7 days)
  List<Task> get upcomingTasks {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.isCompleted) return false;
      final difference = task.dueDate.difference(now);
      return difference.inDays >= 0 && difference.inDays <= 7;
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Toggle task completion
  void toggleTaskCompletion(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }

  // Get tasks for specific module
  List<Task> getModuleTasks(String moduleCode) {
    return _tasks.where((t) => t.moduleCode == moduleCode).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Get materials for specific module
  List<StudyMaterial> getModuleMaterials(String moduleCode) {
    return _materials.where((m) => m.moduleCode == moduleCode).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  // Get module by code
  Module? getModuleByCode(String code) {
    try {
      return _modules.firstWhere((m) => m.code == code);
    } catch (e) {
      return null;
    }
  }

  // Add new task
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Add new material
  void addMaterial(StudyMaterial material) {
    _materials.add(material);
    notifyListeners();
  }

  // Delete task
  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // Delete material
  void deleteMaterial(String materialId) {
    _materials.removeWhere((m) => m.id == materialId);
    notifyListeners();
  }

  // Update task
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
