import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:projet_flutter/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({String? firstName, String? lastName}) {
    return repository.updateProfile(firstName: firstName, lastName: lastName);
  }
}
