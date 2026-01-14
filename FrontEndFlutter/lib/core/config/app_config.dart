/// Configuration générale de l'application
/// Variables d'environnement et paramètres globaux

class AppConfig {
  // Base URL de l'API backend
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

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
