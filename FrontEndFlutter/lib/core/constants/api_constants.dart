/// Constantes pour les appels API
class ApiConstants {
  // Base URL - À configurer selon l'environnement
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  
  static const String sessions = '/sessions';
  static const String projects = '/projects';
  static const String tasks = '/tasks';
  static const String habits = '/habits';
  static const String capsules = '/capsules';
  static const String circle = '/circle';
  
  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentTypeJson = 'application/json';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
