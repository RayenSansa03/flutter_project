import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart' as fs;

abstract class FocusSessionRepository {
  Future<Either<Failure, List<fs.FocusSession>>> getSessions();
  Future<Either<Failure, fs.FocusSession>> createSession(fs.FocusSession session, List<String>? invitedUserIds);
  Future<Either<Failure, fs.FocusSession>> updateSession(String id, Map<String, dynamic> data);
  Future<Either<Failure, fs.FocusSession>> joinSession(String id);
  Future<Either<Failure, void>> leaveSession(String id);
  Future<Either<Failure, void>> deleteSession(String id);
}
