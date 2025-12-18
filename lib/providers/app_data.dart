import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/task.dart';
import '../models/study_material.dart';
import '../models/calendar_event.dart';
import '../utils/colors.dart';
import '../database/database_helper.dart';

class AppData extends ChangeNotifier {
  List<Module> _modules = [];
  List<Task> _tasks = [];
  List<StudyMaterial> _materials = [];

  bool _isLoading = true;
  bool _isInitialized = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AppData() {
    _loadDataFromDatabase();
  }

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  List<Module> get modules => _modules;
  List<Task> get tasks => _tasks;
  List<StudyMaterial> get materials => _materials;

  // Load all data from database
  Future<void> _loadDataFromDatabase() async {
    _isLoading = true;
    notifyListeners();

    try {
      _modules = await _dbHelper.getAllModules();
      _tasks = await _dbHelper.getAllTasks();
      _materials = await _dbHelper.getAllMaterials();

      // If database is empty, initialize with sample data
      if (_modules.isEmpty && !_isInitialized) {
        await _initializeSampleData();
        _isInitialized = true;
      }
    } catch (e) {
      debugPrint('Error loading data from database: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Initialize with sample data (saved to database)
  Future<void> _initializeSampleData() async {
    final sampleModules = [
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

    final sampleTasks = [
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

    final sampleMaterials = [
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

    // Insert sample data into database
    debugPrint('Initializing database with sample data...');

    for (var module in sampleModules) {
      await _dbHelper.insertModule(module);
      debugPrint('Added module: ${module.name}');
    }

    for (var task in sampleTasks) {
      await _dbHelper.insertTask(task);
      debugPrint('Added task: ${task.title}');
    }

    for (var material in sampleMaterials) {
      await _dbHelper.insertMaterial(material);
      debugPrint('Added material: ${material.title}');
    }

    // Reload data from database
    _modules = await _dbHelper.getAllModules();
    _tasks = await _dbHelper.getAllTasks();
    _materials = await _dbHelper.getAllMaterials();

    debugPrint('Sample data initialization complete!');
    debugPrint(
        'Loaded ${_modules.length} modules, ${_tasks.length} tasks, ${_materials.length} materials');
  }

  // Calendar events (generated from tasks)
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

  int get pendingTasksCount {
    return _tasks.where((task) => !task.isCompleted).length;
  }

  int get overdueTasksCount {
    return _tasks.where((task) => task.isOverdue).length;
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.isCompleted) return false;
      final difference = task.dueDate.difference(now);
      return difference.inDays >= 0 && difference.inDays <= 7;
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // ==================== TASK METHODS ====================

  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      await _dbHelper.updateTask(_tasks[taskIndex]);
      notifyListeners();
      debugPrint('Task ${_tasks[taskIndex].title} completion toggled');
    }
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.insertTask(task);
    _tasks.add(task);
    notifyListeners();
    debugPrint('Task added: ${task.title}');
  }

  Future<void> deleteTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    await _dbHelper.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
    debugPrint('Task deleted: ${task.title}');
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _dbHelper.updateTask(updatedTask);
      notifyListeners();
      debugPrint('Task updated: ${updatedTask.title}');
    }
  }

  List<Task> getModuleTasks(String moduleCode) {
    return _tasks.where((t) => t.moduleCode == moduleCode).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // ==================== MATERIAL METHODS ====================

  Future<void> addMaterial(StudyMaterial material) async {
    await _dbHelper.insertMaterial(material);
    _materials.add(material);
    notifyListeners();
    debugPrint('Material added: ${material.title}');
  }

  Future<void> deleteMaterial(String materialId) async {
    final material = _materials.firstWhere((m) => m.id == materialId);
    await _dbHelper.deleteMaterial(materialId);
    _materials.removeWhere((m) => m.id == materialId);
    notifyListeners();
    debugPrint('Material deleted: ${material.title}');
  }

  Future<void> updateMaterial(StudyMaterial updatedMaterial) async {
    final index = _materials.indexWhere((m) => m.id == updatedMaterial.id);
    if (index != -1) {
      _materials[index] = updatedMaterial;
      await _dbHelper.updateMaterial(updatedMaterial);
      notifyListeners();
      debugPrint('Material updated: ${updatedMaterial.title}');
    }
  }

  List<StudyMaterial> getModuleMaterials(String moduleCode) {
    return _materials.where((m) => m.moduleCode == moduleCode).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  // ==================== MODULE METHODS ====================

  Module? getModuleByCode(String code) {
    try {
      return _modules.firstWhere((m) => m.code == code);
    } catch (e) {
      return null;
    }
  }

  Future<void> addModule(Module module) async {
    await _dbHelper.insertModule(module);
    _modules.add(module);
    notifyListeners();
    debugPrint('Module added: ${module.name}');
  }

  Future<void> deleteModule(String moduleId) async {
    final module = _modules.firstWhere((m) => m.id == moduleId);
    await _dbHelper.deleteModule(moduleId);
    _modules.removeWhere((m) => m.id == moduleId);
    notifyListeners();
    debugPrint('Module deleted: ${module.name}');
  }

  Future<void> updateModule(Module updatedModule) async {
    final index = _modules.indexWhere((m) => m.id == updatedModule.id);
    if (index != -1) {
      _modules[index] = updatedModule;
      await _dbHelper.updateModule(updatedModule);
      notifyListeners();
      debugPrint('Module updated: ${updatedModule.name}');
    }
  }

  // ==================== UTILITY METHODS ====================

  Future<void> refreshData() async {
    await _loadDataFromDatabase();
    debugPrint('Data refreshed from database');
  }

  Future<void> clearAllData() async {
    await _dbHelper.deleteAllData();
    _modules.clear();
    _tasks.clear();
    _materials.clear();
    _isInitialized = false;
    notifyListeners();
    debugPrint('All data cleared from database');
  }

  Future<void> reinitializeData() async {
    await clearAllData();
    await _initializeSampleData();
    debugPrint('Data reinitialized with sample data');
  }
}
