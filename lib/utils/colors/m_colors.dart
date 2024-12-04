import 'package:flutter/material.dart';
import 'package:note_app/utils/tools/hex_to_color.dart';

class AppColors {
  static Color darkColor = hexToColor('#333333');
  static Color? cardColor = Colors.grey[850];

//colors for the app
  static Color primaryColor = hexToColor('#E0D3AFFF');
  static Color secondaryColor = hexToColor('#171B1E');
  static Color subTextColor = hexToColor('#B5A006');
  static Color greyTextColor = hexToColor('#798084');
  static Color scaffoldLightColor = hexToColor('#FAFAFA');

  static Color primaryGrey = hexToColor('#F9F9F9');
  static Color secondaryGrey = hexToColor('#F5F5F5');
  static Color lightGrey = hexToColor('#F1F1F1');
  static Color primaryGold = hexToColor('#C9B902');
  static Color transparent = Colors.transparent;
  static Color btnBorderColor = hexToColor('#CCE8D4');
  static Color textFieldBorderColor = hexToColor('#938989');

  static Color borderColor = hexToColor('#EBECED');
  static Color green = hexToColor('#009A51');
  static Color darkGreen = hexToColor('#006D3A');
  static Color red = hexToColor('#F83446');
  static Color darkRed = hexToColor('#B02532');
  static Color redWarning = hexToColor('#FEEBED');

  static Color dialogColor = Colors.white;
  static Color backColorOne = Colors.white;
  static Color defaultTextColor = Colors.black;


  static Color boxColor = const Color.fromRGBO(235, 237, 242, 1);

  static Color grey = hexToColor('#AFACAB');

//other colors
  static Color defaultWhite = const Color.fromRGBO(255, 255, 255, 1);
  static Color defaultBlack = const Color.fromRGBO(0, 0, 0, 1);
//

  static Color btnSecondaryTextCode = const Color.fromRGBO(255, 255, 255, 1);
  static Color btnPrimaryTextCode = const Color.fromRGBO(0, 0, 0, 1);

}