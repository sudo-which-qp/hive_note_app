import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/presentation/widget/mNew_text_widget.dart';
import 'package:note_app/presentation/widget/mbutton.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool offText = true;
  bool isLoading = false;
  bool isAuthLoading = false;

  String? identifier;
  String? password;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              MNewTextField(
                fieldName: 'Username / Email',
                onSave: (val) {
                  setState(() {
                    identifier = val;
                  });
                },
              ),
              MNewTextField(
                fieldName: 'Password',
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
                title: 'Login',
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
                height: 20.h,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don\'t have an Account? ',
                      style: TextStyle(
                        color: context.watch<ThemeCubit>().state.isDarkTheme == false
                            ? AppColors.defaultBlack
                            : AppColors.defaultWhite,
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // context.pushNamed(RoutesName.register_screen);
                        },
                        child: Text(
                          'Create One',
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
