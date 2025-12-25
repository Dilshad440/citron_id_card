import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.backgroundColor,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.height = 40,
    this.width,
    this.icon,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.generateGradientColors(),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          backgroundColor:backgroundColor?? AppColors.generateGradientColors()[1],
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyle.body.medium.semiBold.copyWith(
                color: textColor ?? AppColors.textOnGradient,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                color: AppColors.textOnGradient,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
