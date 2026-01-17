import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart';

class FocusSessionModel extends FocusSession {
  const FocusSessionModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    required super.status,
    required super.isGroup,
    super.startTime,
    super.endTime,
    required super.durationMinutes,
    super.members,
  });

  factory FocusSessionModel.fromJson(Map<String, dynamic> json) {
    return FocusSessionModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'] ?? 'Study Session',
      description: json['description'],
      status: _mapStatus(json['status']),
      isGroup: json['isGroup'] ?? false,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      durationMinutes: json['durationMinutes'] ?? 25,
      members: json['members'] != null
          ? (json['members'] as List)
              .map((m) => SessionMemberModel.fromJson(m))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final desc = description;
    final start = startTime;
    final map = <String, dynamic>{
      'title': title,
      'isGroup': isGroup,
      'durationMinutes': durationMinutes,
    };
    if (desc != null) map['description'] = desc;
    if (start != null) map['startTime'] = start.toUtc().toIso8601String();
    return map;
  }

  static FocusSessionStatus _mapStatus(String? status) {
    switch (status) {
      case 'planned':
        return FocusSessionStatus.planned;
      case 'active':
        return FocusSessionStatus.active;
      case 'completed':
        return FocusSessionStatus.completed;
      case 'cancelled':
        return FocusSessionStatus.cancelled;
      default:
        return FocusSessionStatus.planned;
    }
  }
}

class SessionMemberModel extends SessionMember {
  const SessionMemberModel({
    required super.id,
    required super.userId,
    super.userName,
    super.userPhotoUrl,
  });

  factory SessionMemberModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return SessionMemberModel(
      id: json['id'],
      userId: json['userId'],
      userName: user != null ? '${user['firstName']} ${user['lastName']}' : null,
      userPhotoUrl: user != null ? user['image'] : null,
    );
  }
}
