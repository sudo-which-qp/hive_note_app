import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/app/src/app.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/services/service_locator.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';
import 'package:note_app/state/cubits/cloud_note_cubit/cloud_note_cubit.dart';
import 'package:note_app/state/cubits/note_style_cubit/note_style_cubit.dart';
import 'package:note_app/state/cubits/play_button_cubit/play_button_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/constant/api_constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // initialize hive
  await HiveManager().init();

  loadApiCredentials();

  // Setup dependency injection
  await setupLocator();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(prefs),
        ),
        BlocProvider<PlayButtonCubit>(
          create: (context) => PlayButtonCubit(),
        ),
        BlocProvider<NoteStyleCubit>(
          create: (context) => NoteStyleCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider<CloudNoteCubit>(
          create: (context) => getIt<CloudNoteCubit>(),
        ),
      ],
      child: const App(),
    ),
  );
}

Future<void> loadApiCredentials() async {
  String yamlString = await rootBundle.loadString('api_credentials.yaml');
  Map<dynamic, dynamic> yamlMap = loadYaml(yamlString);
  Map<String, dynamic> credentialsMap = Map<String, dynamic>.from(yamlMap);
  ApiConstants.apiUrl = credentialsMap['api_url'];
}
