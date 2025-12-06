class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String type;
  final String moduleCode;
  final String location;
  final String description;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    required this.moduleCode,
    this.location = '',
    this.description = '',
  });

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays >= 0 && difference.inDays <= 7;
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      moduleCode: json['moduleCode'],
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'type': type,
      'moduleCode': moduleCode,
      'location': location,
      'description': description,
    };
  }

  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? type,
    String? moduleCode,
    String? location,
    String? description,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      moduleCode: moduleCode ?? this.moduleCode,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
}
