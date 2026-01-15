import 'package:equatable/equatable.dart';
import 'package:projet_flutter/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailVerificationRequired extends AuthState {
  final String tempToken;
  final String email;

  const EmailVerificationRequired({
    required this.tempToken,
    required this.email,
  });

  @override
  List<Object?> get props => [tempToken, email];
}
