import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart' as fs;
import 'package:projet_flutter/features/focus_session/domain/repositories/focus_session_repository.dart';
import 'package:projet_flutter/features/focus_session/data/datasources/focus_session_remote_datasource.dart';
import 'package:projet_flutter/features/focus_session/data/models/focus_session_model.dart';

class FocusSessionRepositoryImpl implements FocusSessionRepository {
  final FocusSessionRemoteDataSource remoteDataSource;

  FocusSessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<fs.FocusSession>>> getSessions() async {
    try {
      final sessions = await remoteDataSource.getSessions();
      return Right(sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, fs.FocusSession>> createSession(fs.FocusSession session, List<String>? invitedUserIds) async {
    try {
      final model = FocusSessionModel(
        id: session.id,
        userId: session.userId,
        title: session.title,
        description: session.description,
        status: session.status,
        isGroup: session.isGroup,
        startTime: session.startTime,
        endTime: session.endTime,
        durationMinutes: session.durationMinutes,
      );
      final result = await remoteDataSource.createSession(model, invitedUserIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, fs.FocusSession>> updateSession(String id, Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.updateSession(id, data);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, fs.FocusSession>> joinSession(String id) async {
    try {
      final result = await remoteDataSource.joinSession(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> leaveSession(String id) async {
    try {
      await remoteDataSource.leaveSession(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      await remoteDataSource.deleteSession(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
