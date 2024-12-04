import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on int {
  Widget get toHeight {
    return SizedBox(
      height: toDouble().h,
    );
  }

  Widget get toWidth {
    return SizedBox(
      width: toDouble().w,
    );
  }
}