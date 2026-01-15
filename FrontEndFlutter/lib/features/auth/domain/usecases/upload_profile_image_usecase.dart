import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:projet_flutter/features/auth/domain/repositories/auth_repository.dart';

class UploadProfileImageUseCase {
  final AuthRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String imagePath) {
    return repository.uploadProfileImage(imagePath);
  }
}
