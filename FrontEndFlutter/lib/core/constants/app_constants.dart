/// Constantes générales de l'application

class AppConstants {
  // Noms des routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String sessionsRoute = '/sessions';
  static const String projectsRoute = '/projects';
  static const String tasksRoute = '/tasks';
  static const String habitsRoute = '/habits';
  static const String capsulesRoute = '/capsules';
  static const String circleRoute = '/circle';

  // Durées d'animation
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Limites de pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
