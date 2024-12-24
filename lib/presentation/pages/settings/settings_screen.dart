import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/config/router/navigates_to.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/presentation/pages/trash/trashed_notes.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';
import 'package:note_app/state/cubits/play_button_cubit/play_button_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:note_app/utils/tools/sized_box_ex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  bool isLoading = false;
  bool isLoadingRemoveKeys = false;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = HiveManager().userModelBox;
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  //Body here
                  const SizedBox(
                    child: Column(
                      children: [
                        Text(
                          'VNotes',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'VNotes is a simple lite Note taking app, here to make Note taking easy.',
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(
                        context.watch<ThemeCubit>().state.isDarkTheme == false
                            ? Icons.brightness_3
                            : Icons.brightness_6),
                    title: const Text(
                      'Enable Dark Theme',
                      style: TextStyle(),
                    ),
                    trailing: Switch(
                      value: context.watch<ThemeCubit>().state.isDarkTheme,
                      onChanged: (val) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.play_arrow),
                    title: const Text(
                      'Hide Play Button',
                      style: TextStyle(),
                    ),
                    subtitle: const Text(
                      'This will disable or hide the play '
                      'in the read note screen',
                    ),
                    trailing: Switch(
                      value: context.watch<PlayButtonCubit>().state.canPlay,
                      onChanged: (val) {
                        context.read<PlayButtonCubit>().togglePlayButton();
                      },
                    ),
                  ),
                  10.toHeight,
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text(
                      'Trash',
                      style: TextStyle(),
                    ),
                    subtitle: const Text(
                      'You can recover any note you delete and'
                      ' also delete them permanently',
                      style: TextStyle(),
                    ),
                    onTap: () {
                      navigateTo(context, destination: RoutesName.trash_notes);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  userModel.get(tokenKey) == null
                      ? const SizedBox.shrink()
                      : BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return state is AuthAuthenticated ? ListTile(
                              leading: const Icon(Icons.logout),
                              title: Text(
                                isLoading == false
                                    ? 'Logout'
                                    : 'Please wait...',
                              ),
                              subtitle: const Text(
                                'This will log you out of you cloud account',
                                style: TextStyle(),
                              ),
                              onTap: () {
                                context.read<AuthCubit>().logout().then((value) {
                                  showSuccess('Logout successful');
                                });
                              },
                            ) : const SizedBox.shrink();
                          },
                        ),
                ],
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Platform.isAndroid
                    ? Text('$packageName Version $version')
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text('$packageName Version $version'),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
