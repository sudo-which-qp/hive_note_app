import 'package:note_app/config/router/routes_name.dart';

class RoutesGuard {
  static final protectedRoutes = [
    RoutesName.cloud_notes,
    RoutesName.cloud_create_notes_screen,
  ];

  static bool requiresAuth(String? routeName) {
    return protectedRoutes.contains(routeName);
  }
}