import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:note_app/data/exceptions/app_exceptions.dart';
import 'package:note_app/data/models/cloud_note_models/user_model.dart';
import 'package:note_app/data/repositories/auth_repository.dart';
import 'package:note_app/utils/const_values.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  String? _attemptedRoute;


  AuthCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    checkAuthStatus();
  }

  void saveAttemptedRoute(String route) {
    _attemptedRoute = route;
  }

  String? getAndClearAttemptedRoute() {
    final route = _attemptedRoute;
    _attemptedRoute = null;
    return route;
  }

  Future<void> checkAuthStatus() async {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
        // Show the exact message from API
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

}
