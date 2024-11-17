import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/core/auth_status.dart';
import 'package:taxi_park/data/repository/data_repo.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required DataRepo authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final DataRepo _authenticationRepository;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.authStream,
      onData: (status) async {
        switch (status) {
          case AuthStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());
          case AuthStatus.authenticated:
            return emit(
              const AuthenticationState.authenticated(),
            );
          case AuthStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logout();
  }
}
