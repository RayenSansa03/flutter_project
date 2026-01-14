/// Failures pour le pattern Either (Success/Failure)
/// Utilisé avec le package dartz

import 'package:dartz/dartz.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';

/// Failure de base
abstract class Failure {
  final String message;
  Failure(this.message);
}

/// Failure réseau
class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

/// Failure serveur
class ServerFailure extends Failure {
  ServerFailure(super.message);
}

/// Failure non autorisé
class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(super.message);
}

/// Failure validation
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  ValidationFailure(super.message, {this.errors});
}

/// Failure ressource non trouvée
class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

/// Mapper les exceptions en failures
Failure mapExceptionToFailure(Exception exception) {
  if (exception is NetworkException) {
    return NetworkFailure(exception.message);
  } else if (exception is ServerException) {
    return ServerFailure(exception.message);
  } else if (exception is UnauthorizedException) {
    return UnauthorizedFailure(exception.message);
  } else if (exception is ValidationException) {
    return ValidationFailure(exception.message, errors: exception.errors);
  } else if (exception is NotFoundException) {
    return NotFoundFailure(exception.message);
  } else {
    return ServerFailure('Une erreur inattendue s\'est produite');
  }
}

/// Type alias pour Either avec Failure
typedef Result<T> = Either<Failure, T>;
