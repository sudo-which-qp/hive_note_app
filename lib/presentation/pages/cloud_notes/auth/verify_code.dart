import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/router/route_name.dart';
import 'package:note_app/request/post_request.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:note_app/widget/mbutton.dart';
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

  Future sendCode() async {
    setState(() {
      isLoading = true;
    });

    final userModel = HiveManager().userModelBox;

    var params = {
      'email': '${widget.email}',
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/auth/send_code',
      params: params,
      context: context,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 200) {
        startTimer();
        showSuccess('Code Sent');
      }
    } catch (error) {
      if (error.toString().contains('Unhandled Exception')) {
        showError('Something went wrong, it\'s not you it\'s us.');
      }
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future verifyCode() async {
    setState(() {
      isLoadingVerify = true;
    });

    final userModel = HiveManager().userModelBox;

    var params = {
      'otp_code': code,
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/auth/verify_code',
      params: params,
      context: context,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 200) {
        showSuccess('$msg');
        if(mounted) {
          if(widget.from == 'register_screen') {
            context.pop();
            context.pushReplacementNamed(RouteName.cloud_notes);
          } else {
            Navigator.pop(context);
          }
        }
      }
    } catch (error) {
      if (error.toString().contains('Unhandled Exception')) {
        showError('Something went wrong, it\'s not you it\'s us.');
      }
      setState(() {
        isLoadingVerify = false;
      });
    } finally {
      setState(() {
        isLoadingVerify = false;
      });
    }
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
                context.watch<ThemeCubit>().state.isDarkTheme == false ? defaultBlack : defaultWhite,
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
                      verifyCode();
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
                          sendCode();
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
