import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/data/models/cloud_note_models/user_model.dart';
import 'package:note_app/app/router/route_name.dart';
import 'package:note_app/request/post_request.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:note_app/widget/mNew_text_widget.dart';
import 'package:note_app/widget/mbutton.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  bool offText = true;
  bool isLoading = false;
  bool isAuthLoading = false;

  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;

  Future validateDetails() async {
    setState(() {
      isLoading = true;
    });

    final userModel = HiveManager().userModelBox;

    var params = {
      'first_name': '$firstName',
      'last_name': '$lastName',
      'email': '$email',
      'username': '$username',
      'password': '$password',
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/auth/register',
      params: params,
      context: context,
      vEmail: email,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 201) {
        showSuccess(msg);
        UserModel user = UserModel.fromJsonUserDetails(res);
        userModel.put(userKey, user);

        UserModel tokenModel = UserModel.fromJsonLocalToken(res);
        userModel.put(tokenKey, tokenModel);

          context.pushNamed(RouteName.verify_code_screen, queryParameters: {
            'from': 'register_screen',
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MNewTextField(
                      fieldName: '',
                      sideText: 'First Name',
                      onSave: (val) {
                        setState(() {
                          firstName = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: MNewTextField(
                      fieldName: '',
                      sideText: 'Last Name',
                      onSave: (val) {
                        setState(() {
                          lastName = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              MNewTextField(
                fieldName: '',
                sideText: 'Email',
                onSave: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              MNewTextField(
                fieldName: '',
                sideText: 'Username',
                onSave: (val) {
                  setState(() {
                    username = val;
                  });
                },
              ),
              MNewTextField(
                fieldName: '',
                sideText: 'Password',
                isPasswordField: true,
                offText: offText,
                togglePasswordView: () {
                  setState(() {
                    offText = !offText;
                  });
                },
                onSave: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              MButton(
                title: 'Continue',
                isLoading: isLoading,
                onPressed: isLoading == false
                    ? () {
                  var form = formKey.currentState;

                  if (form!.validate()) {
                    form.save();

                    validateDetails();
                  }
                }
                    : null,
              ),
              SizedBox(
                height: 15.h,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an Account? ',
                      style: TextStyle(
                        color: context.watch<ThemeCubit>().state.isDarkTheme == false
                            ? defaultBlack
                            : defaultWhite,
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: context.watch<ThemeCubit>().state.isDarkTheme == false
                                ? defaultBlack
                                : defaultWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
