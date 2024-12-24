import 'package:note_app/config/router/routes_name.dart';

class RoutesGuard {
  static final protectedRoutes = [
    RoutesName.cloud_notes,
    RoutesName.cloud_create_notes_screen,
    RoutesName.cloud_edit_notes_screen,
    RoutesName.cloud_read_notes_screen,
  ];

  static final requiresVerification = [
    ...protectedRoutes,
  ];

  static bool requiresAuth(String? routeName) {
    return protectedRoutes.contains(routeName);
  }

  static bool requiresEmailVerification(String? routeName) {
    return requiresVerification.contains(routeName);
  }
}