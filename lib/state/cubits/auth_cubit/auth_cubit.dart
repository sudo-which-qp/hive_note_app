import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:note_app/data/exceptions/app_exceptions.dart';
import 'package:note_app/data/models/cloud_note_models/user_model.dart';
import 'package:note_app/data/repositories/auth_repository.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/tools/message_dialog.dart';

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
    final token = _authRepository.getCurrentUserToken();
    if (token != null) {
      final user = _authRepository.getCurrentUser();
      if (user?.emailVerified == null || user?.emailVerified == 'null') {
        emit(AuthEmailUnverified(user!));
      } else {
        emit(AuthAuthenticated(user!));
      }
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

      if (e is UnauthorisedException &&
          e.toString().contains('not yet verified')) {
        logger.i('Handling unverified user in cubit');
        final user = _authRepository.getCurrentUser();
        if (user != null) {
          // Emit both the error message and the unverified state
          emit(AuthError(e.toString()));
          emit(AuthEmailUnverified(user,));
        }
      } else if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userName,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        userName: userName,
      );
      emit(AuthEmailUnverified(user));
    } catch (e) {
      if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> verifyEmail(String code) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyEmail(code);
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        showSuccess('You have been verified successfully.');
        // Make sure to get attempted route before emitting new state
        final attemptedRoute = _attemptedRoute;
        emit(AuthAuthenticated(user));
        // Set attempted route if needed
        if (attemptedRoute != null) {
          saveAttemptedRoute(attemptedRoute);
        }
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> resendVerificationCode() async {
    emit(AuthLoading());
    try {
      await _authRepository.resendVerificationCode();
      emit(AuthEmailUnverified(_authRepository.getCurrentUser()!));
      showSuccess('Code sent');
    } catch (e) {
      if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
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
