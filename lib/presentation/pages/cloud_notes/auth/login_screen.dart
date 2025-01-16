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

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Get saved route and navigate
          final attemptedRoute =
              context.read<AuthCubit>().getAndClearAttemptedRoute();
          navigateReplaceTo(context, destination: attemptedRoute ?? RoutesName.cloud_notes);
        } else if(state is AuthEmailUnverified) {
          navigateReplaceTo(context, destination: RoutesName.verify_code_screen, arguments: {
            'from': 'login',
          });
        } else if (state is AuthError) {
          showError(state.message);
        }
      },
      child: Scaffold(
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
                  controller: _identifierController,
                ),
                MNewTextField(
                  fieldName: 'Password',
                  controller: _passwordController,
                  isPasswordField: true,
                  offText: offText,
                  togglePasswordView: () {
                    setState(() {
                      offText = !offText;
                    });
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return MButton(
                      title: 'Login',
                      isLoading: state is AuthLoading,
                      onPressed: state is! AuthLoading
                          ? () {
                              var form = formKey.currentState;

                              if (form!.validate()) {
                                form.save();
                                context.read<AuthCubit>().login(
                                  _identifierController.text!,
                                  _passwordController.text!,
                                );
                              }
                            }
                          : null,
                    );
                  },
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
                            navigateTo(context, destination: RoutesName.register_screen);
                          },
                          child: Text(
                            'Create One',
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
