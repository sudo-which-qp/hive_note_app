import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel {
  @HiveField(1)
  final int? id;

  @HiveField(2)
  final String? uuid;

  @HiveField(3)
  final String? firstName;

  @HiveField(4)
  final String? lastName;

  @HiveField(5)
  final String? userName;

  @HiveField(6)
  final String? email;

  @HiveField(7)
  final String? emailVerified;

  @HiveField(8)
  final int? hasSubscription;

  @HiveField(9)
  final int? hasExceedTier;

  @HiveField(10)
  final String? planDuration;

  @HiveField(11)
  final String? planSubDate;

  @HiveField(12)
  final String? accessToken;

  UserModel({
    this.id,
    this.uuid,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.emailVerified,
    this.hasSubscription,
    this.hasExceedTier,
    this.planDuration,
    this.planSubDate,
    this.accessToken,
  });


  factory UserModel.fromJsonLocalToken(responseData) {
    return UserModel(
      accessToken: responseData['data']['token'],
    );
  }

  factory UserModel.fromJsonUserDetails(responseData) {
    return UserModel(
      id: responseData['data']['user']['id'],
      uuid: responseData['data']['user']['uuid'],
      firstName: responseData['data']['user']['first_name'],
      lastName: responseData['data']['user']['last_name'],
      userName: responseData['data']['user']['username'],
      email: responseData['data']['user']['email'],
      emailVerified: responseData['data']['user']['email_verified_at'],
      hasSubscription: responseData['data']['user']['has_subscription'],
      hasExceedTier: responseData['data']['user']['has_exceed_tier'],
      planDuration: responseData['data']['user']['plan_duration'],
      planSubDate: responseData['data']['user']['plan_sub_date'],
    );
  }
}