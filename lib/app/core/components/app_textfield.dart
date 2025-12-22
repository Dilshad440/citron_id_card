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
    this.isFilled=false,
  });

  final Function(String val)? onChanged;
  final TextEditingController? controller;
  final String? Function(String? val)? validator;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final int maxLines;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      autofocus: false,
      cursorColor: AppColors.teal,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      /// Medium but compact text
      style: AppTextStyle.body.medium.black.medium,

      decoration: InputDecoration(
        prefixIcon: prefix,
        filled: isFilled,
        fillColor: AppColors.teal.withOpacity(0.1),

        /// ⬇ Reduced vertical padding (key change)
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        /// Texts
        labelText: labelText,
        hintText: hintText,
        labelStyle: AppTextStyle.title.small.black.regular,
        hintStyle: AppTextStyle.body.small.black.regular,
        errorStyle: AppTextStyle.body.small.red.regular,

        /// Borders (unchanged theme)
        enabledBorder: _border(),
        focusedBorder: _border(
          color: AppColors.teal,
          width: 1.3,
        ),
        errorBorder: _border(
          color: AppColors.red,
        ),
        focusedErrorBorder: _border(
          color: AppColors.red,
          width: 1.3,
        ),

        counter: const SizedBox.shrink(),
        isDense: true, // 🔥 Important for compact height
      ),
    );
  }

  OutlineInputBorder _border({
    Color? color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: (color ?? AppColors.teal).withOpacity(0.6),
        width: width,
      ),
    );
  }
}
