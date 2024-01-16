// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  String name;
  String email;
  String password; 

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthGoogleRegisterRequested extends AuthEvent{}

class AuthLoginRequested extends AuthEvent {
  String email;
  String password;
  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

class AuthSignOut extends AuthEvent{}

class ShowPassword extends AuthEvent {
  bool isPassShowed;
  ShowPassword({
    required this.isPassShowed,
  });
}
