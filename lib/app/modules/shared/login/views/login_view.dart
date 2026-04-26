import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/components/overlay_loader.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:citron_id_card/app/core/constants/asset_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/app_textfield.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [

          /// ✅ Main UI (NO Obx here)
          _buildStack(context),

          /// ✅ Loader Overlay (separate)


          GetBuilder<LoginController>(builder: (controller) {
            return OverlayIdCardLoader(child: (isLoading) => SizedBox(),
                isLoading: controller.isLoading.value);
          },)
        ],
      ),
    );
  }

  Widget _buildStack(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final double topHeight = size.height * 0.24;
    final double bottomHeight = size.height * 0.22;

    return Stack(
      children: [
        _topCard(topHeight),
        _bottomCard(bottomHeight),

        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              20,
              24,
              20,
              MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom + 20,
            ),
            child: _loginCard(),
          ),
        ),
      ],
    );
  }

  Positioned _topCard(double height) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: height,
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

  Positioned _bottomCard(double height) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: height,
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
            const SizedBox(height: 10),
            Text(
              "Powered By Citron Software",
              style: AppTextStyle.title.medium.regular.textOnGradient,
            ),
            Text(
              "© ${DateTime
                  .now()
                  .year} Citron Software. All rights reserved.",
              style: AppTextStyle.title.small.lightWeight.italic.copyWith(
                color: AppColors.borderColor,
              ),
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
        key: controller.formKey, // ✅ SAFE now (only one Form exists)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextStyle.display.large.textColor.bold.text("Welcome Back"),
            const SizedBox(height: 6),
            AppTextStyle.body.medium.textColor.text("Login to your account"),
            const SizedBox(height: 20),

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
                  () =>
                  TwoLineElement(
                    title: "Password",
                    child: AppTextField(
                      controller: controller.passwordController,
                      isObsecure: controller.isPasswordVisible.value,
                      hintText: "Enter password",
                      suffix: IconButton(
                        onPressed: controller.togglePasswordVisibility,
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      validator: (val) =>
                      val!.isEmpty
                          ? "Password required"
                          : null,
                    ),
                  ),
            ),

            const SizedBox(height: 28),

            AppButton(
              text: "Login",
              onPressed: controller.onLogin,
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
