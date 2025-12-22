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
    this.maxLines = 1,
    this.isFilled = false,
    this.suffix,
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
  final bool isFilled;
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

      /// Medium but compact text
      style: AppTextStyle.body.medium.textColor.medium,

      decoration: InputDecoration(
        prefixIcon: prefix,
        constraints: suffix != null ? BoxConstraints(maxHeight: 40) : null,
        suffixIcon: suffix,

        filled: true,
        fillColor: AppColors.borderColor.withOpacity(0.9),

        /// ⬇ Reduced vertical padding (key change)
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        /// Texts
        labelText: labelText,
        hintText: hintText,
        labelStyle: AppTextStyle.title.small.mutedTextColor.regular,
        hintStyle: AppTextStyle.body.small.mutedTextColor.regular,
        errorStyle: AppTextStyle.body.small.red.regular,

        /// Borders (unchanged theme)
        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.borderColor, width: 1.3),
        errorBorder: _border(color: AppColors.red),
        focusedErrorBorder: _border(color: AppColors.red, width: 1.3),

        counter: const SizedBox.shrink(),
        isDense: true, // 🔥 Important for compact height
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
