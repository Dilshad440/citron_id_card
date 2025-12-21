import 'package:citron_id_card/app/core/constant/asset_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/app_buttons.dart';
import '../../../core/components/app_dropdown.dart';
import '../../../core/components/app_textfield.dart';
import '../../../core/components/common_appbbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final height = media.size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final cardWidth = constraints.maxWidth > 450
              ? 420.0
              : constraints.maxWidth * 0.92;

          return Stack(
            children: [
              /// 🔹 TOP TEAL ACCENT
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: isMobile ? height * 0.26 : 200,
                  padding: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetConstant.idCard,
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 10),
                      AppTextStyle.display.large.white.text(
                        "ID Card Generator",
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔹 BOTTOM TEAL ACCENT
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: isMobile ? height * 0.26 : 200,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.75),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Text("Ciron Logo Here..."),
                      ),
                      SizedBox(height: 15),
                      AppTextStyle.title.small.white.text(
                        "Powered by Citron Software.",
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔹 CENTER LOGIN CARD
              Center(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                    vertical: 24,
                  ),
                  child: Container(
                    width: cardWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          AppTextStyle.display.large.black.bold.text(
                            'Welcome Back',
                          ),

                          const SizedBox(height: 6),

                          AppTextStyle.body.small.grey.text(
                            'Login to your account',
                          ),

                          const SizedBox(height: 32),

                          /// User Type
                          Obx(
                            () => AppDropdown<String>(
                              hintText: 'Select user type',
                              value: controller.selectedUserType.value.isEmpty
                                  ? null
                                  : controller.selectedUserType.value,
                              items: controller.userTypes,
                              onChanged: (val) =>
                                  controller.selectedUserType.value = val ?? '',
                              validator: (val) =>
                                  val == null ? 'Select user type' : null,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Username
                          AppTextField(
                            controller: controller.usernameController,
                            hintText: 'Enter username',
                            validator: (val) => val == null || val.isEmpty
                                ? 'Username is required'
                                : null,
                          ),

                          const SizedBox(height: 20),

                          /// Password
                          AppTextField(
                            controller: controller.passwordController,
                            hintText: 'Enter password',
                            validator: (val) => val == null || val.isEmpty
                                ? 'Password is required'
                                : null,
                          ),

                          const SizedBox(height: 32),

                          /// Login Button
                          AppButton(
                            text: 'Login',
                            height: 44,
                            onPressed: controller.onLogin,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
