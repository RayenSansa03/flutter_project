/// Intercepteur pour la gestion centralisée des erreurs
/// Transforme les erreurs HTTP en exceptions personnalisées

import 'package:dio/dio.dart';
import 'package:projet_flutter/core/errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Transformer les erreurs Dio en exceptions personnalisées
    Exception exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = NetworkException('Timeout: Vérifiez votre connexion internet');
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 404) {
          exception = NotFoundException('Ressource non trouvée');
        } else if (statusCode == 401) {
          exception = UnauthorizedException('Non autorisé');
        } else if (statusCode == 403) {
          exception = ForbiddenException('Accès interdit');
        } else if (statusCode! >= 500) {
          exception = ServerException('Erreur serveur');
        } else {
          exception = ApiException(
            'Erreur API: ${err.response?.statusMessage ?? 'Erreur inconnue'}',
            statusCode: statusCode,
          );
        }
        break;

      case DioExceptionType.cancel:
        exception = CancelException('Requête annulée');
        break;

      case DioExceptionType.unknown:
      default:
        exception = NetworkException('Erreur réseau: ${err.message}');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
        message: exception.toString(),
      ),
    );
  }
}
