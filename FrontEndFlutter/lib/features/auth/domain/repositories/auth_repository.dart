import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, String>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });
  Future<Either<Failure, UserEntity>> verifyEmail(String tempToken, String code);
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isAuthenticated();
}
