import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:citron_id_card/app/core/constant/asset_constant.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/app_dropdown.dart';
import '../../../core/components/app_textfield.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 🔥 Important
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: _buildStack(constraints),
          );
        },
      ),
    );
  }

  Widget _buildStack(BoxConstraints constraints) {
    final maxHeight = constraints.maxHeight;
    final double topHeight = maxHeight * 0.24;
    final double bottomHeight = maxHeight * 0.22;

    return Stack(
      children: [
        /// 🌿 TOP GRADIENT
        _topCard(topHeight),

        /// 🌿 BOTTOM GRADIENT
        _bottomCard(bottomHeight),

        /// 🧾 CENTER LOGIN CARD
        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
            ),
            child: _loginCard(),
          ),
        ),
      ],
    );
  }

  Positioned _bottomCard(double topHeight) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: topHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.generateGradientColors(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderColor, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(AssetConstant.logo),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Powered By Citron Software",
              style: AppTextStyle.title.medium.regular.textOnGradient,
            ),
            Text(
              "© ${DateTime.now().year} Citron Software. All rights reserved.",
              style: AppTextStyle.title.small.lightWeight.italic.copyWith(
                color: AppColors.borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _topCard(double topHeight) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: topHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.generateGradientColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
          ),
          image: DecorationImage(
            image: AssetImage(AssetConstant.hill),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            opacity: 0.18,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(AssetConstant.idCard, height: 80),
            const SizedBox(height: 12),
            AppTextStyle.display.large.textColor.bold.text("ID Card Generator"),
            const SizedBox(height: 6),
            AppTextStyle.body.medium.textColor.regular.text(
              "Create & Manage ID Cards",
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.generateGradientColors(),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextStyle.display.large.textColor.bold.text("Welcome Back"),
            const SizedBox(height: 6),
            AppTextStyle.body.medium.textColor.text("Login to your account"),
            const SizedBox(height: 20),

            /// User Type
            Obx(
              () => TwoLineElement(
                title: "User Type",
                child: AppDropdown<String>(
                  hintText: "Select user type",
                  value: controller.selectedUserType.value.isEmpty
                      ? null
                      : controller.selectedUserType.value,
                  items: controller.userTypes,
                  onChanged: (val) =>
                      controller.selectedUserType.value = val ?? '',
                  validator: (val) => val == null ? 'Select user type' : null,
                ),
              ),
            ),

            const SizedBox(height: 10),

            TwoLineElement(
              title: "Username",
              child: AppTextField(
                controller: controller.usernameController,
                hintText: "Enter username",
                validator: (val) => val!.isEmpty ? "Username required" : null,
              ),
            ),

            const SizedBox(height: 10),

            Obx(
              () => TwoLineElement(
                title: "Password",
                child: AppTextField(
                  controller: controller.passwordController,
                  isObsecure: controller.isPasswordVisible.value,
                  hintText: "Enter password",
                  suffix: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? "Password required" : null,
                ),
              ),
            ),

            const SizedBox(height: 28),

            AppButton(
              text: "Login",
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  final userType = controller.selectedUserType.value;
                  if (userType.toLowerCase() == "parent") {
                    Get.toNamed(AppRoutes.enterAdmissionNumber);
                  } else {
                    Get.toNamed(AppRoutes.idCard);
                  }
                }
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
