import 'package:equatable/equatable.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart';

abstract class FocusSessionState extends Equatable {
  const FocusSessionState();
  @override
  List<Object?> get props => [];
}

class FocusSessionInitial extends FocusSessionState {}
class FocusSessionLoading extends FocusSessionState {}

class FocusSessionLoaded extends FocusSessionState {
  final List<FocusSession> sessions;
  const FocusSessionLoaded(this.sessions);
  @override
  List<Object?> get props => [sessions];
}

class FocusSessionInPogress extends FocusSessionState {
  final FocusSession? session;
  final int secondsRemaining;
  final int totalSeconds;
  final bool isPaused;
  final String currentMessage;

  const FocusSessionInPogress({
    this.session,
    required this.secondsRemaining,
    required this.totalSeconds,
    this.isPaused = false,
    this.currentMessage = 'Concentration maximale...',
  });

  double get progress => (totalSeconds - secondsRemaining) / totalSeconds;

  @override
  List<Object?> get props => [session, secondsRemaining, totalSeconds, isPaused, currentMessage];
}

class FocusSessionFinished extends FocusSessionState {
  final FocusSession session;
  final int actualDurationMinutes;
  const FocusSessionFinished(this.session, this.actualDurationMinutes);
  @override
  List<Object?> get props => [session, actualDurationMinutes];
}

class FocusSessionError extends FocusSessionState {
  final String message;
  const FocusSessionError(this.message);
  @override
  List<Object?> get props => [message];
}
