import 'package:flutter/material.dart';
import 'package:note_app/config/router/route_guard.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/presentation/views.dart';
import 'package:note_app/services/service_locator.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final authCubit = getIt<AuthCubit>();
    final state = authCubit.state;
    final args = settings.arguments as Map<String, dynamic>?;

    if (RoutesGuard.requiresAuth(settings.name)) {
      if (state is AuthEmailUnverified) {
        return MaterialPageRoute(
          builder: (_) => const VerifyCode(from: 'protected_route'),
          maintainState: true, // Preserve route state
        );
      }

      if (state is! AuthAuthenticated) {
        authCubit.saveAttemptedRoute(settings.name!);
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          maintainState: true,
        );
      }
    }

    switch (settings.name) {
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

      case RoutesName.trash_notes:
        return MaterialPageRoute(builder: (_) => const TrashedNotes());
      //

      // Local Notes
      case RoutesName.read_notes_screen:
        return MaterialPageRoute(
            builder: (_) => ReadNotesScreen(
                  note: args!['note'],
                  noteKey: args['noteKey'],
                ));

      case RoutesName.edit_notes_screen:
        return MaterialPageRoute(
            builder: (_) => EditNoteScreen(
                  notes: args!['notes'],
                  noteKey: args['noteKey'],
                ));
      // ends here

      // Cloud Notes
      case RoutesName.cloud_create_notes_screen:
        return MaterialPageRoute(builder: (_) => const CloudCreateNote());

      case RoutesName.cloud_read_notes_screen:
        return MaterialPageRoute(
            builder: (_) => CloudReadNote(
              note: args!['note'],
              noteKey: args['noteKey'],
            ));

      case RoutesName.cloud_edit_notes_screen:
        return MaterialPageRoute(
            builder: (_) => CloudEditNote(
              notes: args!['notes'],
              noteKey: args['noteKey'],
            ));
      // ends here

      //Auth
      case RoutesName.login_screen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesName.register_screen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RoutesName.verify_code_screen:
        return MaterialPageRoute(
            builder: (_) => VerifyCode(
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
