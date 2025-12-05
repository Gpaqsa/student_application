// lib/models/module.dart
// Data model for academic modules/courses
// Represents a single course with all its properties

import 'package:flutter/material.dart';

class Module {
  final String id;
  final String name;
  final String code;
  final String instructor;
  final double grade;
  final Color color;
  final String description;
  final List<String> syllabus;

  Module({
    required this.id,
    required this.name,
    required this.code,
    required this.instructor,
    required this.grade,
    required this.color,
    this.description = '',
    this.syllabus = const [],
  });

  // Factory constructor to create from JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      instructor: json['instructor'],
      grade: json['grade'].toDouble(),
      color: Color(json['color']),
      description: json['description'] ?? '',
      syllabus: List<String>.from(json['syllabus'] ?? []),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'instructor': instructor,
      'grade': grade,
      'color': color.value,
      'description': description,
      'syllabus': syllabus,
    };
  }

  // Copy with method for immutable updates
  Module copyWith({
    String? id,
    String? name,
    String? code,
    String? instructor,
    double? grade,
    Color? color,
    String? description,
    List<String>? syllabus,
  }) {
    return Module(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      instructor: instructor ?? this.instructor,
      grade: grade ?? this.grade,
      color: color ?? this.color,
      description: description ?? this.description,
      syllabus: syllabus ?? this.syllabus,
    );
  }
}
