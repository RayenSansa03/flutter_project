/// Exceptions personnalisées pour la gestion des erreurs

/// Exception de base pour toutes les exceptions de l'application
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception réseau (timeout, pas de connexion, etc.)
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Exception API (erreurs 4xx, 5xx)
class ApiException extends AppException {
  final int? statusCode;
  ApiException(super.message, {this.statusCode});
}

/// Exception serveur (erreurs 5xx)
class ServerException extends AppException {
  ServerException(super.message);
}

/// Exception non autorisé (401)
class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

/// Exception accès interdit (403)
class ForbiddenException extends AppException {
  ForbiddenException(super.message);
}

/// Exception ressource non trouvée (404)
class NotFoundException extends AppException {
  NotFoundException(super.message);
}

/// Exception validation (400)
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;
  ValidationException(super.message, {this.errors});
}

/// Exception requête annulée
class CancelException extends AppException {
  CancelException(super.message);
}
