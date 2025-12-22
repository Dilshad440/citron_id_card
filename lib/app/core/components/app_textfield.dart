import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.isObsecure = false,
  });

  final Function(String val)? onChanged;
  final TextEditingController? controller;
  final String? Function(String? val)? validator;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLines;
  final bool isObsecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecure,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      autofocus: false,
      cursorColor: AppColors.primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppTextStyle.body.medium.textColor.medium,

      decoration: InputDecoration(
        prefixIcon: prefix,

        /// ✅ FIX: control suffix size
        suffixIcon: suffix == null
            ? null
            : SizedBox(width: 38, height: 38, child: Center(child: suffix)),

        suffixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 38,
        ),

        filled: true,
        fillColor: AppColors.borderColor.withOpacity(0.9),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        labelText: labelText,
        hintText: hintText,
        labelStyle: AppTextStyle.title.small.mutedTextColor.regular,
        hintStyle: AppTextStyle.body.small.mutedTextColor.regular,
        errorStyle: AppTextStyle.body.small.red.regular,

        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.borderColor, width: 1.3),
        errorBorder: _border(color: AppColors.red),
        focusedErrorBorder: _border(color: AppColors.red, width: 1.3),

        isDense: true,
      ),
    );
  }

  OutlineInputBorder _border({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: (color ?? AppColors.borderColor).withOpacity(0.6),
        width: width,
      ),
    );
  }
}
