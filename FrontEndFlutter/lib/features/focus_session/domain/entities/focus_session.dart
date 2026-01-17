import 'package:equatable/equatable.dart';

enum FocusSessionStatus { planned, active, completed, cancelled }

class FocusSession extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final FocusSessionStatus status;
  final bool isGroup;
  final DateTime? startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final List<SessionMember>? members;

  const FocusSession({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.status,
    required this.isGroup,
    this.startTime,
    this.endTime,
    required this.durationMinutes,
    this.members,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        status,
        isGroup,
        startTime,
        endTime,
        durationMinutes,
        members,
      ];
}

class SessionMember extends Equatable {
  final String id;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;

  const SessionMember({
    required this.id,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
  });

  @override
  List<Object?> get props => [id, userId, userName, userPhotoUrl];
}
