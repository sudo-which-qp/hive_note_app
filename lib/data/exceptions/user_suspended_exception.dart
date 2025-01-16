class UserSuspendedException implements Exception {
  final String message;
  UserSuspendedException(this.message);
  @override
  String toString() => message;
}