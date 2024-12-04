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
      id: responseData['data']['id'],
      uuid: responseData['data']['uuid'],
      firstName: responseData['data']['first_name'],
      lastName: responseData['data']['last_name'],
      userName: responseData['data']['username'],
      email: responseData['data']['email'],
      emailVerified: responseData['data']['email_verified_at'],
      hasSubscription: responseData['data']['has_subscription'],
      hasExceedTier: responseData['data']['has_exceed_tier'],
      planDuration: responseData['data']['plan_duration'],
      planSubDate: responseData['data']['plan_sub_date'],
    );
  }
}