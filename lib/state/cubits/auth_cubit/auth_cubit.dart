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
    _loadInitialState();
  }

  void saveAttemptedRoute(String route) {
    _attemptedRoute = route;
  }

  String? getAndClearAttemptedRoute() {
    final route = _attemptedRoute;
    _attemptedRoute = null;
    return route;
  }

  Future<void> _loadInitialState() async {
    final token = _authRepository.getCurrentUserToken();
    final user = _authRepository.getCurrentUser();

    if (token == null) {
      emit(AuthUnauthenticated());
      return;
    }

    if (user != null) {
      logger.i('Email of user: ${user.emailVerified}');
      if (user.emailVerified == null || user.emailVerified == 'null') {
        emit(AuthEmailUnverified(user));
      } else {
        emit(AuthAuthenticated(user));
      }
    }

    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = _authRepository.getCurrentUserToken();
    if (token != null) {
      try {
        final freshUserData = await _authRepository.fetchUserDetails();

        if (freshUserData?.emailVerified == null ||
            freshUserData?.emailVerified == 'null') {
          emit(AuthEmailUnverified(freshUserData!));
        } else {
          emit(AuthAuthenticated(freshUserData!));
        }
      } catch (e) {

        if (e.toString().contains('not verified')) {
          final user = _authRepository.getCurrentUser();
          if (user != null) {
            emit(AuthEmailUnverified(user));
          }
        } else if (e.toString().contains('suspended')) {
          emit(const AuthError('Account suspended'));
          await _authRepository.logout();
        } else {
          emit(AuthError(e.toString()));
        }
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
        final attemptedRoute = _attemptedRoute;
        emit(AuthAuthenticated(user));
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

  Future<void> resendVerificationCode({String? email}) async {
    emit(AuthLoading());
    try {
      if(email != null) {
        await _authRepository.resendVerificationCode(email: email);
        emit(AuthInitial());
        showSuccess('Code sent');
      } else {
        await _authRepository.resendVerificationCode();
        emit(AuthEmailUnverified(_authRepository.getCurrentUser()!));
        showSuccess('Code sent');
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await _authRepository.forgotPassword(email);
      emit(AuthSuccess());
      showSuccess('Code sent');
    } catch (e) {
      if (e is NoInternetException) {
        emit(const AuthError('No internet connection'));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> resetPassword(String otpCode, String newPassword) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(otpCode, newPassword);
      emit(AuthSuccess());
      showSuccess('Password reset');
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
