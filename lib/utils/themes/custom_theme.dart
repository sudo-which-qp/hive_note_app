import 'package:flutter/material.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/const_values.dart';

ThemeData buildLightTheme() => ThemeData.light().copyWith(
      cardColor: Colors.white,
      scaffoldBackgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(
        color: AppColors.defaultBlack,
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.primaryColor,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      dividerColor: AppColors.defaultBlack,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[900],
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
            (states) => TextStyle(
              color: AppColors.defaultBlack,
            ),
          ),
        ),
      ),
      dialogBackgroundColor: AppColors.primaryColor,
      textTheme: Typography.blackCupertino,
    );

ThemeData buildDarkTheme() => ThemeData.dark().copyWith(
      cardColor: Colors.grey[850],
      scaffoldBackgroundColor: AppColors.darkColor,
      dividerColor: AppColors.defaultWhite,
      iconTheme: IconThemeData(
        color: AppColors.defaultWhite,
      ),
      cardTheme: CardTheme(
        color: AppColors.cardColor,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[900],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => Colors.grey[400],
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors.grey[400],
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
            (states) => TextStyle(
              color: AppColors.defaultBlack,
            ),
          ),
        ),
      ),
      textTheme: Typography.whiteCupertino,
    );
