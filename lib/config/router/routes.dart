import 'package:flutter/material.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/helpers/wrapper.dart';
import 'package:note_app/presentation/views.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract the arguments
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      // Middleware Wrapper
      case RoutesName.wrapper:
        return MaterialPageRoute(builder: (_) => const Wrapper());
      // ends here

      //
      case RoutesName.home_screen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RoutesName.local_notes:
        return MaterialPageRoute(builder: (_) => const LocalNotesScreen());

      case RoutesName.cloud_notes:
        return MaterialPageRoute(builder: (_) => const CloudNotesScreen());

      case RoutesName.settings_screen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case RoutesName.create_notes_screen:
        return MaterialPageRoute(builder: (_) => const CreateNoteScreen());
      //

      // Cloud Notes
      case RoutesName.cloud_create_notes_screen:
        return MaterialPageRoute(builder: (_) => const CloudCreateNote());
      // ends here

      //Auth
      case RoutesName.login_screen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesName.register_screen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RoutesName.verify_code_screen:
        return MaterialPageRoute(builder: (_) => VerifyCode(
          from: args!['from'],
        ));
      // ends here

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'No Routes Generated',
                ),
              ),
            );
          },
        );
    }
  }
}
