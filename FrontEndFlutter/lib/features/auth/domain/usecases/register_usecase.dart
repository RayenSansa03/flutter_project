import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) {
    return repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
