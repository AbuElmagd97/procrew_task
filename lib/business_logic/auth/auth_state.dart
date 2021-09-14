part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class ErrorOccurred extends AuthState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class NotAuthenticated extends AuthState {
  NotAuthenticated();
}
