/// Configuration générale de l'application
/// Variables d'environnement et paramètres globaux

import 'package:flutter/foundation.dart';

class AppConfig {
  // Base URL de l'API backend
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000/api',
  );

  static String get ragBaseUrl {
    const envUrl = String.fromEnvironment('RAG_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;
    if (kIsWeb) return 'http://127.0.0.1:8001';
    // Sur Android Emulator, localhost est 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8001';
    return 'http://127.0.0.1:8001';
  }

  // Timeout pour les requêtes HTTP
  static const Duration requestTimeout = Duration(seconds: 30);

  // Configuration de l'environnement
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // Debug mode
  static const bool debugMode = environment == 'development';
}
