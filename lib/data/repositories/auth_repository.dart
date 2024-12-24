import 'package:note_app/data/exceptions/app_exceptions.dart';
import 'package:note_app/data/models/cloud_note_models/user_model.dart';
import 'package:note_app/data/network/network_services_api.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/utils/const_values.dart';

class AuthRepository {
  final NetworkServicesApi _api;
  final HiveManager _hiveManager;

  AuthRepository({
    required NetworkServicesApi api,
    required HiveManager hiveManager,
  })  : _api = api,
        _hiveManager = hiveManager;

  Future<UserModel> login(String email, String password) async {
    final response = await _api.postApi(
      requestEnd: 'user/auth/authenticate',
      params: {
        'identifier': email,
        'password': password,
      },
    );

    logger.i(response);

    if (response['success'] == false &&
        response['message'].contains('not yet verified')) {
      final token = UserModel.fromJsonLocalToken(response);
      final user = UserModel.fromJsonUserDetails(response);
      await _hiveManager.userModelBox.put(tokenKey, token);
      await _hiveManager.userModelBox.put(userKey, user);

      // Check what's stored in Hive
      logger.i('Stored Token: ${_hiveManager.userModelBox.get(tokenKey)}');
      logger.i('Stored User: ${_hiveManager.userModelBox.get(userKey)}');
      logger.i('Stored User Email: ${_hiveManager.userModelBox.get(userKey)?.email}');

      throw UnauthorisedException(response['message']);
    }

    if (response['success'] == true) {
      final token = UserModel.fromJsonLocalToken(response);
      final user = UserModel.fromJsonUserDetails(response);
      await _hiveManager.userModelBox.put(tokenKey, token);
      await _hiveManager.userModelBox.put(userKey, user);
      return user;
    }

    throw response['message'];
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userName,
  }) async {
    final response = await _api.postApi(
      requestEnd: 'user/auth/register',
      params: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'username': userName,
      },
    );

    logger.i(response);

    if (response['success'] == true) {
      final token = UserModel.fromJsonLocalToken(response);
      final user = UserModel.fromJsonUserDetails(response);
      await _hiveManager.userModelBox.put(tokenKey, token);
      await _hiveManager.userModelBox.put(userKey, user);
      return user;
    } else {
      throw response['message'];
    }
  }

  Future<void> verifyEmail(String code) async {
    final response = await _api.postApi(
      requestEnd: 'user/auth/verify_code',
      params: {
        'otp_code': code,
      },
    );

    logger.i(response);

    if (response['success'] != true) {
      throw response['message'];
    }
  }

  Future<void> resendVerificationCode() async {
    final user = _hiveManager.userModelBox.get(userKey);
    logger.i('Stored User: $user');
    logger.i('User Email: ${user?.email}');

    if (user?.email == null) {
      logger.e('User email is null');
      throw 'User email not found';
    }
    final response = await _api.postApi(
      requestEnd: 'user/auth/send_code',
      params: {
        'email': user!.email,
      },
    );

    logger.i(response);

    if (response['success'] == false) {
      throw response['message'];
    }
  }

  Future<void> logout() async {
    await _hiveManager.userModelBox.delete(tokenKey);
  }

  UserModel? getCurrentUser() {
    return _hiveManager.userModelBox.get(userKey);
  }

  UserModel? getCurrentUserToken() {
    return _hiveManager.userModelBox.get(tokenKey);
  }

}