import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/greetings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VNotes'),
        // TODO:* adding support for localization soon.
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(RouteName.settings_screen);
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Hi 👋🏾, ${greetingMessage()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: context.watch<ThemeCubit>().state.isDarkTheme == false
                      ? backColor.withOpacity(0.7)
                      : cardColor,
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(RouteName.local_notes);
                    },
                    child: Container(
                      height: 200.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sd_storage_outlined,
                              size: 100.r,
                              color: context.watch<ThemeCubit>().state.isDarkTheme == false
                                  ? defaultBlack
                                  : defaultWhite,
                            ),
                            Text(
                              'Local Note',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: context.watch<ThemeCubit>().state.isDarkTheme == false
                      ? backColor.withOpacity(0.7)
                      : cardColor,
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(RouteName.wrapper);
                    },
                    child: Container(
                      height: 200.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_queue_outlined,
                              size: 100.r,
                              color: context.watch<ThemeCubit>().state.isDarkTheme == false
                                  ? defaultBlack
                                  : defaultWhite,
                            ),
                            Text(
                              'Cloud Note',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
