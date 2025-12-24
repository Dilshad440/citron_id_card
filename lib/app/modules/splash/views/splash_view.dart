import 'package:citron_id_card/app/core/constant/asset_constant.dart';
import 'package:citron_id_card/app/core/theme/app_colors.dart';
import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.generateGradientColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Image.asset(
                AssetConstant.splash,
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              // App Name
              AppTextStyle.display.large.textColor.bold.text(
                "ID Card Generator",
              ),
              const SizedBox(height: 8),
              // Tagline
              AppTextStyle.body.medium.textColor.regular.text(
                "Create & Manage ID Cards",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

