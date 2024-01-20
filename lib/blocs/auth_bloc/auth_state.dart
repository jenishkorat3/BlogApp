part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthSLoading extends AuthState {}

final class AuthFailure extends AuthState {
  String error;

  AuthFailure({
    required this.error,
  });
}

final class AuthForgotPasswordLoading extends AuthState {}

final class AuthForgotPasswordEmailSent extends AuthState {}


final class AuthForgotPasswordNotEmailSent extends AuthState {
  String error;

  AuthForgotPasswordNotEmailSent({
    required this.error,
  });
}

final class PasswordShown extends AuthState{}

final class PasswordHidden extends AuthState{}
