import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.isCompleted,
    super.time,
    super.duration,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Parse time: Supporte "HH:MM" (RAG) et ISO 8601 (Backend DB)
    DateTime? taskTime;
    if (json['time'] != null) {
      final timeStr = json['time'].toString();
      if (timeStr.contains(':') && !timeStr.contains('T') && !timeStr.contains('-')) {
        // Format "HH:MM" (RAG)
        final parts = timeStr.split(':');
        final now = DateTime.now();
        taskTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      } else {
        // Format ISO 8601 (Backend DB)
        taskTime = DateTime.tryParse(timeStr);
      }
    }

    // Parse duration: Supporte "XX min" (RAG) et entier durationMinutes (Backend DB)
    Duration? taskDuration;
    if (json['durationMinutes'] != null) {
      taskDuration = Duration(minutes: json['durationMinutes'] as int);
    } else if (json['duration'] != null) {
      final durationStr = json['duration'].toString().toLowerCase();
      final cleanValue = durationStr.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanValue.isNotEmpty) {
        int minutes = int.parse(cleanValue);
        if (durationStr.contains('heure') || durationStr.contains('hour')) {
          minutes *= 60;
        }
        taskDuration = Duration(minutes: minutes);
      }
    }

    return TaskModel(
      id: json['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['activity'] ?? json['title'] ?? 'Sans titre',
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      time: taskTime,
      duration: taskDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'time': time?.toIso8601String(),
      'durationMinutes': duration?.inMinutes,
    };
  }
}
