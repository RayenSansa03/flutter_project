/// Intercepteur pour l'authentification
/// Ajoute automatiquement le token JWT aux requêtes

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Récupérer le token depuis le stockage sécurisé
    final token = await _storage.read(key: _tokenKey);
    
    // N'ajouter le token que pour les requêtes vers l'API principale
    final isBackendRequest = !options.path.startsWith('http') || 
                             options.path.contains('127.0.0.1:3000') ||
                             options.path.contains('localhost:3000');

    if (isBackendRequest && token != null && token.isNotEmpty) {
      // Ajouter le token dans le header Authorization
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Gérer les erreurs 401 (non autorisé)
    if (err.response?.statusCode == 401) {
      // TODO: Déconnecter l'utilisateur et rediriger vers la page de connexion
      // _storage.delete(key: _tokenKey);
    }

    handler.next(err);
  }
}
