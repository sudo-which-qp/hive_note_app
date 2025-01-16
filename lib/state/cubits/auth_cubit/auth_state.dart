part of 'auth_cubit.dart';

abstract class AuthState  extends Equatable{
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthEmailUnverified extends AuthState {
  final UserModel user;
  const AuthEmailUnverified(this.user);

  @override
  List<Object?> get props => [user];
}
