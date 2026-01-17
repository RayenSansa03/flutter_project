import 'package:equatable/equatable.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart';

abstract class FocusSessionEvent extends Equatable {
  const FocusSessionEvent();
  @override
  List<Object?> get props => [];
}

class LoadSessionsEvent extends FocusSessionEvent {}

class CreateSessionEvent extends FocusSessionEvent {
  final FocusSession session;
  final List<String>? invitedUserIds;
  const CreateSessionEvent(this.session, {this.invitedUserIds});
  @override
  List<Object?> get props => [session, invitedUserIds];
}

class StartTimerEvent extends FocusSessionEvent {
  final int durationMinutes;
  const StartTimerEvent(this.durationMinutes);
  @override
  List<Object?> get props => [durationMinutes];
}

class TimerTickEvent extends FocusSessionEvent {
  final int secondsRemaining;
  const TimerTickEvent(this.secondsRemaining);
  @override
  List<Object?> get props => [secondsRemaining];
}

class PauseTimerEvent extends FocusSessionEvent {}
class ResumeTimerEvent extends FocusSessionEvent {}

class CompleteSessionEvent extends FocusSessionEvent {
  final String sessionId;
  const CompleteSessionEvent(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class JoinSessionEvent extends FocusSessionEvent {
  final String sessionId;
  const JoinSessionEvent(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class LeaveSessionEvent extends FocusSessionEvent {
  final String sessionId;
  const LeaveSessionEvent(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}
