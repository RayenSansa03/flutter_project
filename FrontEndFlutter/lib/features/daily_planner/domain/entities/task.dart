import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final IconData? icon;
  final DateTime? time;
  final Duration? duration;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.icon,
    this.time,
    this.duration,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    IconData? icon,
    DateTime? time,
    Duration? duration,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      icon: icon ?? this.icon,
      time: time ?? this.time,
      duration: duration ?? this.duration,
    );
  }
}
