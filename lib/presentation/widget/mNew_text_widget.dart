import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/tools/money_formatter.dart';
import 'package:note_app/utils/tools/sized_box_ex.dart';

class MNewTextField extends StatefulWidget {
  final double? height;
  final double? width;
  final int? maxLines;
  final int? maxLength;
  final String? sideText;
  final String? sideTextTwo;
  final String? fieldKey;
  final String? fieldName;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final TextAlign? textAlign;
  final FormFieldSetter<String>? onSave;
  final FormFieldSetter<String>? onChange;

  // final VoidCallback? onTap;
  final String? hintText;
  final String? leftIconImage;
  final String? rightIconImage;
  final double? fontSize;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;
  final IconData? leftIcon;
  final bool isNumber;
  final bool isMoneyFormat;
  final bool isEmail;
  final bool isTransferPin;
  final bool isBVN;
  final bool isAccountNumber;
  final bool allowSymbols;
  final bool offText;
  final bool isPasswordField;
  final bool realOnly;
  final bool autofocus;
  final bool validateError;
  final bool removeBottomPadding;
  final VoidCallback? togglePasswordView;

  const MNewTextField({
    Key? key,
    this.height,
    this.width,
    this.maxLines,
    this.maxLength,
    this.fieldKey,
    required this.fieldName,
    this.sideText,
    this.sideTextTwo,
    this.initialValue,
    this.textInputAction,
    this.textCapitalization,
    this.textAlign,
    this.onSave,
    this.onChange,
    // this.onTap,
    this.leftIconImage,
    this.rightIconImage,
    this.hintText = '',
    this.fontSize,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.leftIcon,
    this.isNumber = false,
    this.isMoneyFormat = false,
    this.isEmail = false,
    this.isTransferPin = false,
    this.isBVN = false,
    this.isAccountNumber = false,
    this.allowSymbols = true,
    this.offText = false,
    this.isPasswordField = false,
    this.realOnly = false,
    this.autofocus = false,
    this.validateError = true,
    this.removeBottomPadding = false,
    this.togglePasswordView,
  }) : super(key: key);

  @override
  _MNewTextFieldState createState() => _MNewTextFieldState();
}

class _MNewTextFieldState extends State<MNewTextField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
  builder: (context, state) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              widget.sideText == null
                  ? const SizedBox()
                  : Text(
                      '${widget.sideText}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: state.isDarkTheme == false
                            ? AppColors.defaultBlack
                            : AppColors.defaultWhite,
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        TextFormField(
          initialValue: widget.initialValue,
          key: Key(widget.fieldKey.toString()),
          obscureText: widget.offText,
          validator: widget.validateError == true
              ? (String? val) {
                  if (val!.isEmpty) {
                    return 'Field must not be empty';
                  } else {
                    return null;
                  }
                }
              : null,
          readOnly: widget.realOnly,
          onSaved: widget.onSave,
          onChanged: widget.onChange,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines ?? 1,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          maxLength: widget.maxLength,
          inputFormatters: widget.allowSymbols == false
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ]
              : widget.isMoneyFormat == true
                  ? [ThousandsSeparatorInputFormatter()]
                  : [],
          keyboardType: widget.isEmail == true
              ? TextInputType.emailAddress
              : widget.isNumber == true
                  ? TextInputType.number
                  : TextInputType.text,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: transparent,
            suffixIcon: widget.isPasswordField == false
                ? widget.rightIconImage == null
                    ? null
                    : Image.asset(
                        '${widget.rightIconImage}',
                        width: 18.w,
                        height: 18.w,
                      )
                : IconButton(
                    icon: widget.offText == true
                        ? FaIcon(
                            FontAwesomeIcons.eye,
                            color: state.isDarkTheme == false
                                ? AppColors.defaultBlack
                                : AppColors.defaultWhite,
                          )
                        : FaIcon(
                            FontAwesomeIcons.eyeSlash,
                            color: state.isDarkTheme == false
                                ? AppColors.defaultBlack
                                : AppColors.defaultWhite,
                          ),
                    onPressed: widget.togglePasswordView,
                  ),
            prefixIcon: widget.leftIcon == null
                ? null
                : Icon(
                    widget.leftIcon,
                    color: grey.withOpacity(0.4),
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: state.isDarkTheme == false ? AppColors.defaultBlack : AppColors.defaultWhite,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: state.isDarkTheme == false ? AppColors.defaultBlack : AppColors.defaultWhite,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: state.isDarkTheme == false ? AppColors.defaultBlack : AppColors.defaultWhite,
              ),
            ),
            hintText: '${widget.fieldName}',
            hintStyle: TextStyle(
              color: state.isDarkTheme == false ? AppColors.defaultBlack : AppColors.defaultWhite,
            ),
          ),
          textAlign: widget.textAlign ?? TextAlign.left,
          style: TextStyle(
            fontSize: 14.sp,
            color: state.isDarkTheme == false ? AppColors.defaultBlack : AppColors.defaultWhite,
          ),
        ),

        widget.removeBottomPadding == true
            ? const SizedBox()
            : 20.toHeight,
      ],
    );
  },
);
  }
}
