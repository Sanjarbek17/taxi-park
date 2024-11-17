part of 'auth_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthStatus.unknown,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated()
      : this._(status: AuthStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}