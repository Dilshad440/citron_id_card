import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.backgroundColor = AppColors.teal,
    required this.text,
    required this.onPressed,
    this.textColor = AppColors.white,
    this.height = 40,
    this.width,
  });

  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyle.body.medium.black.semiBold.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
