import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/config/router/routes.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/themes/custom_theme.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: context.watch<ThemeCubit>().state.isDarkTheme == false
              ? buildLightTheme()
              : buildDarkTheme(),
          title: 'VNotes',
          builder: FlashyFlushbarProvider.init(),
          initialRoute: RoutesName.home_screen,
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}
