import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/module.dart';
import '../models/task.dart';
import '../models/study_material.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scholarsync.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Modules table
    await db.execute('''
    CREATE TABLE modules (
      id $idType,
      name $textType,
      code $textType,
      instructor $textType,
      grade $realType,
      color $intType,
      description TEXT,
      syllabus TEXT
    )
    ''');

    // Tasks table
    await db.execute('''
    CREATE TABLE tasks (
      id $idType,
      title $textType,
      moduleCode $textType,
      dueDate $textType,
      type $textType,
      description TEXT,
      isCompleted $intType,
      priority $intType
    )
    ''');

    // Study Materials table
    await db.execute('''
    CREATE TABLE study_materials (
      id $idType,
      title $textType,
      type $textType,
      moduleCode $textType,
      uploadDate $textType,
      url TEXT,
      sizeInBytes $intType,
      uploadedBy TEXT
    )
    ''');
  }

  // ==================== MODULES CRUD ====================

  Future<void> insertModule(Module module) async {
    final db = await instance.database;
    await db.insert(
      'modules',
      {
        'id': module.id,
        'name': module.name,
        'code': module.code,
        'instructor': module.instructor,
        'grade': module.grade,
        'color': module.color.value,
        'description': module.description,
        'syllabus': module.syllabus.join('|||'),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Module>> getAllModules() async {
    final db = await instance.database;
    final result = await db.query('modules');

    return result
        .map((json) => Module(
              id: json['id'] as String,
              name: json['name'] as String,
              code: json['code'] as String,
              instructor: json['instructor'] as String,
              grade: json['grade'] as double,
              color: Color(json['color'] as int),
              description: json['description'] as String? ?? '',
              syllabus: (json['syllabus'] as String?)?.split('|||') ?? [],
            ))
        .toList();
  }

  Future<int> updateModule(Module module) async {
    final db = await instance.database;
    return db.update(
      'modules',
      {
        'name': module.name,
        'code': module.code,
        'instructor': module.instructor,
        'grade': module.grade,
        'color': module.color.value,
        'description': module.description,
        'syllabus': module.syllabus.join('|||'),
      },
      where: 'id = ?',
      whereArgs: [module.id],
    );
  }

  Future<int> deleteModule(String id) async {
    final db = await instance.database;
    return await db.delete(
      'modules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== TASKS CRUD ====================

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'moduleCode': task.moduleCode,
        'dueDate': task.dueDate.toIso8601String(),
        'type': task.type,
        'description': task.description,
        'isCompleted': task.isCompleted ? 1 : 0,
        'priority': task.priority,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');

    return result
        .map((json) => Task(
              id: json['id'] as String,
              title: json['title'] as String,
              moduleCode: json['moduleCode'] as String,
              dueDate: DateTime.parse(json['dueDate'] as String),
              type: json['type'] as String,
              description: json['description'] as String? ?? '',
              isCompleted: (json['isCompleted'] as int) == 1,
              priority: json['priority'] as int,
            ))
        .toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      {
        'title': task.title,
        'moduleCode': task.moduleCode,
        'dueDate': task.dueDate.toIso8601String(),
        'type': task.type,
        'description': task.description,
        'isCompleted': task.isCompleted ? 1 : 0,
        'priority': task.priority,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== STUDY MATERIALS CRUD ====================

  Future<void> insertMaterial(StudyMaterial material) async {
    final db = await instance.database;
    await db.insert(
      'study_materials',
      {
        'id': material.id,
        'title': material.title,
        'type': material.type,
        'moduleCode': material.moduleCode,
        'uploadDate': material.uploadDate.toIso8601String(),
        'url': material.url,
        'sizeInBytes': material.sizeInBytes,
        'uploadedBy': material.uploadedBy,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<StudyMaterial>> getAllMaterials() async {
    final db = await instance.database;
    final result = await db.query('study_materials');

    return result
        .map((json) => StudyMaterial(
              id: json['id'] as String,
              title: json['title'] as String,
              type: json['type'] as String,
              moduleCode: json['moduleCode'] as String,
              uploadDate: DateTime.parse(json['uploadDate'] as String),
              url: json['url'] as String? ?? '',
              sizeInBytes: json['sizeInBytes'] as int,
              uploadedBy: json['uploadedBy'] as String? ?? '',
            ))
        .toList();
  }

  Future<int> updateMaterial(StudyMaterial material) async {
    final db = await instance.database;
    return db.update(
      'study_materials',
      {
        'title': material.title,
        'type': material.type,
        'moduleCode': material.moduleCode,
        'uploadDate': material.uploadDate.toIso8601String(),
        'url': material.url,
        'sizeInBytes': material.sizeInBytes,
        'uploadedBy': material.uploadedBy,
      },
      where: 'id = ?',
      whereArgs: [material.id],
    );
  }

  Future<int> deleteMaterial(String id) async {
    final db = await instance.database;
    return await db.delete(
      'study_materials',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== UTILITY METHODS ====================

  Future<void> deleteAllData() async {
    final db = await instance.database;
    await db.delete('modules');
    await db.delete('tasks');
    await db.delete('study_materials');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
