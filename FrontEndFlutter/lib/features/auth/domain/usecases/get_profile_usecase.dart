import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:projet_flutter/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.getProfile();
  }
}
