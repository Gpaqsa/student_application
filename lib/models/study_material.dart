// lib/models/study_material.dart
// Data model for study materials (PDFs, videos, slides)
// Tracks uploaded content for each module

class StudyMaterial {
  final String id;
  final String title;
  final String type;
  final String moduleCode;
  final DateTime uploadDate;
  final String url;
  final int sizeInBytes;
  final String uploadedBy;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.type,
    required this.moduleCode,
    required this.uploadDate,
    this.url = '',
    this.sizeInBytes = 0,
    this.uploadedBy = '',
  });

  // Get formatted file size
  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024)
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Factory constructor from JSON
  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      moduleCode: json['moduleCode'],
      uploadDate: DateTime.parse(json['uploadDate']),
      url: json['url'] ?? '',
      sizeInBytes: json['sizeInBytes'] ?? 0,
      uploadedBy: json['uploadedBy'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'moduleCode': moduleCode,
      'uploadDate': uploadDate.toIso8601String(),
      'url': url,
      'sizeInBytes': sizeInBytes,
      'uploadedBy': uploadedBy,
    };
  }

  // Copy with method
  StudyMaterial copyWith({
    String? id,
    String? title,
    String? type,
    String? moduleCode,
    DateTime? uploadDate,
    String? url,
    int? sizeInBytes,
    String? uploadedBy,
  }) {
    return StudyMaterial(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      moduleCode: moduleCode ?? this.moduleCode,
      uploadDate: uploadDate ?? this.uploadDate,
      url: url ?? this.url,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }
}
