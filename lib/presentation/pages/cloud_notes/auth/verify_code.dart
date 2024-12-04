import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/presentation/widget/mbutton.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:otp_text_field_v2/otp_text_field_v2.dart';
import 'package:provider/provider.dart';

class VerifyCode extends StatefulWidget {
  final String? email;
  final String? from;

  const VerifyCode({
    super.key,
    this.email,
    this.from,
  });

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final formKey = GlobalKey<FormState>();
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  Timer? _timer;
  int _remainingSeconds = 0;

  bool offText = true;
  bool isLoading = false;
  bool isLoadingVerify = false;
  String? code;
  String? email;

  void startTimer() {
    setState(() {
      _remainingSeconds = 150;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            OTPTextFieldV2(
              controller: otpController,
              length: 4,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 60,
              fieldStyle: FieldStyle.box,
              otpFieldStyle: OtpFieldStyle(
                backgroundColor: transparent,
                enabledBorderColor:
                context.watch<ThemeCubit>().state.isDarkTheme == false ? AppColors.defaultBlack : AppColors.defaultWhite,
              ),
              outlineBorderRadius: 8,
              style: TextStyle(
                fontSize: 17.sp,
              ),
              onChanged: (pin) {
                print("Changed: " + pin);
                setState(() {
                  code = pin;
                });
              },
              onCompleted: (pin) {
                print("Completed: " + pin);
                setState(() {
                  code = pin;
                });
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            MButton(
              title: 'Verify OTP',
              hasIcon: true,
              btnIcon: Icons.arrow_forward_ios,
              isLoading: isLoadingVerify,
              onPressed: isLoadingVerify == false
                  ? () {
                      if (code == null || code!.length < 4) {
                        Fluttertoast.showToast(
                          msg: 'Code not complete',
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }
                    }
                  : null,
            ),
            SizedBox(
              height: 15.h,
            ),
            GestureDetector(
              onTap: _remainingSeconds == 0
                  ? isLoading == false
                      ? () {
                        }
                      : null
                  : null,
              child: isLoading == false
                  ? Text(
                      _remainingSeconds == 0
                          ? 'Send Code'
                          : 'Resend code in $_remainingSeconds',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.clip,
                    )
                  : Text(
                      'Sending code...',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.clip,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
