
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
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
                      ? AppColors.primaryColor.withOpacity(0.7)
                      : AppColors.cardColor,
                  child: InkWell(
                    onTap: () {

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
                                  ? AppColors.defaultBlack
                                  : AppColors.defaultWhite,
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
                      ? AppColors.primaryColor.withOpacity(0.7)
                      : AppColors.cardColor,
                  child: InkWell(
                    onTap: () {

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
                                  ? AppColors.defaultBlack
                                  : AppColors.defaultWhite,
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
