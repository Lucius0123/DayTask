import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
  final DateTime dueDate;


  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.dueDate,
    required this.priority,

    required this.description
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    String? description,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      priority: priority ?? this.priority,

    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      dueDate: DateTime.parse(json['due_date']),
      description: json['description'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'due_date': dueDate.toIso8601String(),
      'description': description,
      'priority': priority,
    };
  }

}
