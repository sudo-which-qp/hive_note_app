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

    if (response['success'] == true) {
      final user = UserModel.fromJsonLocalToken(response);
      await _hiveManager.userModelBox.put(tokenKey, user);
      return user;
    } else {
      throw response['message'];
    }
  }

  Future<void> logout() async {
    await _hiveManager.userModelBox.delete(tokenKey);
  }

  UserModel? getCurrentUser() {
    return _hiveManager.userModelBox.get(tokenKey);
  }

}