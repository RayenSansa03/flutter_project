import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/core/errors/failures.dart';
import 'package:projet_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:projet_flutter/features/auth/domain/usecases/logout_usecase.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final LogoutUseCase logoutUseCase;

  // Stocker les données d'inscription pour le renvoi du code
  String? _pendingEmail;
  String? _pendingPassword;
  String? _pendingFirstName;
  String? _pendingLastName;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyEmailUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<ResendVerificationCodeEvent>(_onResendVerificationCode);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await loginUseCase(event.email, event.password);
    
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    // Stocker les données pour le renvoi éventuel
    _pendingEmail = event.email;
    _pendingPassword = event.password;
    _pendingFirstName = event.firstName;
    _pendingLastName = event.lastName;
    
    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
    );
    
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (tempToken) => emit(EmailVerificationRequired(
        tempToken: tempToken,
        email: event.email,
      )),
    );
  }

  Future<void> _onVerifyEmail(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await verifyEmailUseCase(event.tempToken, event.code);
    
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) {
        // Nettoyer les données en attente
        _pendingEmail = null;
        _pendingPassword = null;
        _pendingFirstName = null;
        _pendingLastName = null;
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onResendVerificationCode(
    ResendVerificationCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Stocker les nouvelles données
    _pendingEmail = event.email;
    _pendingPassword = event.password;
    _pendingFirstName = event.firstName;
    _pendingLastName = event.lastName;
    
    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
    );
    
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (tempToken) => emit(EmailVerificationRequired(
        tempToken: tempToken,
        email: event.email,
      )),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await logoutUseCase();
    
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    // TODO: Implémenter la vérification de l'authentification
    emit(AuthUnauthenticated());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Erreur de connexion. Vérifiez votre internet.';
      case ServerFailure:
        return failure.message;
      case UnauthorizedFailure:
        return 'Email ou mot de passe incorrect';
      case ValidationFailure:
        return failure.message;
      default:
        return 'Une erreur inattendue s\'est produite';
    }
  }
}
