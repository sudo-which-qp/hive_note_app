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

  Future validateDetails() async {
    setState(() {
      isLoading = true;
    });

    final userModel = HiveManager().userModelBox;

    var params = {
      'identifier': '$identifier',
      'password': '$password',
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/auth/authenticate',
      params: params,
      context: context,
      vEmail: identifier,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 200) {
        logger.i('Yes');
        showSuccess('Authenticated');
        UserModel user = UserModel.fromJsonUserDetails(res);
        userModel.put(userKey, user);

        UserModel tokenModel = UserModel.fromJsonLocalToken(res);
        userModel.put(tokenKey, tokenModel);

        // UserModel userAuth = UserModel.fromUserAuth(params);
        // userModel.put(userAuthKey, userAuth);
        context.pushReplacementNamed(RouteName.cloud_notes);

        // if (mounted) {
        //   clearAndNavigate(context, path: RouteName.tab_control);
        // }
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

                    validateDetails();
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
                            ? defaultBlack
                            : defaultWhite,
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(RouteName.register_screen);
                        },
                        child: Text(
                          'Create One',
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
