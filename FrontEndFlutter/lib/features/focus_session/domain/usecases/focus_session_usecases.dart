import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart';
import 'package:projet_flutter/features/focus_session/domain/repositories/focus_session_repository.dart';

class GetFocusSessionsUseCase {
  final FocusSessionRepository repository;
  GetFocusSessionsUseCase(this.repository);
  Future<Either<Failure, List<FocusSession>>> call() => repository.getSessions();
}

class CreateFocusSessionUseCase {
  final FocusSessionRepository repository;
  CreateFocusSessionUseCase(this.repository);
  Future<Either<Failure, FocusSession>> call(FocusSession session, [List<String>? invitedUserIds]) => 
      repository.createSession(session, invitedUserIds);
}

class UpdateFocusSessionUseCase {
  final FocusSessionRepository repository;
  UpdateFocusSessionUseCase(this.repository);
  Future<Either<Failure, FocusSession>> call(String id, Map<String, dynamic> data) => 
      repository.updateSession(id, data);
}

class JoinFocusSessionUseCase {
  final FocusSessionRepository repository;
  JoinFocusSessionUseCase(this.repository);
  Future<Either<Failure, FocusSession>> call(String id) => repository.joinSession(id);
}

class LeaveFocusSessionUseCase {
  final FocusSessionRepository repository;
  LeaveFocusSessionUseCase(this.repository);
  Future<Either<Failure, void>> call(String id) => repository.leaveSession(id);
}
