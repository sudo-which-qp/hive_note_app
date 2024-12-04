import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/presentation/widget/mNew_text_widget.dart';
import 'package:note_app/presentation/widget/mbutton.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
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
                            ? AppColors.defaultBlack
                            : AppColors.defaultWhite,
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // context.pop();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: context.watch<ThemeCubit>().state.isDarkTheme == false
                                ? AppColors.defaultBlack
                                : AppColors.defaultWhite,
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
