import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  const RegisterEvent({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();
}

class VerifyEmailEvent extends AuthEvent {
  final String tempToken;
  final String code;

  const VerifyEmailEvent({
    required this.tempToken,
    required this.code,
  });

  @override
  List<Object?> get props => [tempToken, code];
}

class ResendVerificationCodeEvent extends AuthEvent {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  const ResendVerificationCodeEvent({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class GetProfileEvent extends AuthEvent {
  const GetProfileEvent();
}

class UpdateProfileEvent extends AuthEvent {
  final String? firstName;
  final String? lastName;

  const UpdateProfileEvent({this.firstName, this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];
}

class UploadProfileImageEvent extends AuthEvent {
  final String imagePath;

  const UploadProfileImageEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}
