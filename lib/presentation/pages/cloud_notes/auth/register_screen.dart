import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/config/router/navigates_to.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/presentation/widget/mNew_text_widget.dart';
import 'package:note_app/presentation/widget/mbutton.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/tools/message_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  bool offText = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final attemptedRoute =
              context.read<AuthCubit>().getAndClearAttemptedRoute();
          Navigator.pop(context);
          navigateReplaceTo(context,
              destination: attemptedRoute ?? RoutesName.cloud_notes);
        } else if (state is AuthEmailUnverified) {
          navigateReplaceTo(context,
              destination: RoutesName.verify_code_screen,
              arguments: {
                'from': 'login',
              });
        } else if (state is AuthError) {
          showError(state.message);
        }
      },
      child: Scaffold(
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
                        controller: firstNameController,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: MNewTextField(
                        fieldName: '',
                        sideText: 'Last Name',
                        controller: lastNameController,
                      ),
                    ),
                  ],
                ),
                MNewTextField(
                  fieldName: '',
                  sideText: 'Email',
                  controller: emailController,
                ),
                MNewTextField(
                  fieldName: '',
                  sideText: 'Username',
                  controller: usernameController,
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
                  controller: passwordController,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return MButton(
                      title: 'Continue',
                      isLoading: state is AuthLoading,
                      onPressed: state is! AuthLoading
                          ? () {
                              var form = formKey.currentState;

                              if (form!.validate()) {
                                context.read<AuthCubit>().register(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      userName: usernameController.text,
                                      password: passwordController.text,
                                    );
                              }
                            }
                          : null,
                    );
                  },
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
                          color:
                              context.watch<ThemeCubit>().state.isDarkTheme ==
                                      false
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
                              color: context
                                          .watch<ThemeCubit>()
                                          .state
                                          .isDarkTheme ==
                                      false
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
      ),
    );
  }
}
