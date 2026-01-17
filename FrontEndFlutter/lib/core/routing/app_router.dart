import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:projet_flutter/features/auth/presentation/pages/signup_page.dart';
import 'package:projet_flutter/features/auth/presentation/pages/profile_page.dart';
import 'package:projet_flutter/features/home/presentation/pages/home_page.dart';
import 'package:projet_flutter/features/daily_planner/presentation/pages/daily_planner_page.dart';
import 'package:projet_flutter/features/focus_session/presentation/pages/create_session_page.dart';
import 'package:projet_flutter/features/focus_session/presentation/pages/focus_timer_page.dart';
import 'package:projet_flutter/features/focus_session/presentation/pages/session_summary_page.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_state.dart';

import 'package:projet_flutter/core/config/di_config.dart';
import 'dart:async';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = getIt<AuthBloc>().state;
      final bool loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (authState is AuthInitial || authState is AuthLoading) {
        return null; // Stay at initialLocation while checking auth
      }

      if (authState is! AuthAuthenticated) {
        if (loggingIn) return null;
        return '/login';
      }

      if (loggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/daily-planner',
        name: 'daily_planner',
        builder: (context, state) => const DailyPlannerPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/create-session',
        name: 'create_session',
        builder: (context, state) => const CreateSessionPage(),
      ),
      GoRoute(
        path: '/focus',
        name: 'focus',
        builder: (context, state) => const FocusTimerPage(),
      ),
      GoRoute(
        path: '/session-summary',
        name: 'session_summary',
        builder: (context, state) {
          final duration = state.extra as int? ?? 45;
          return SessionSummaryPage(durationMinutes: duration);
        },
      ),
    ],
  );
}


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
