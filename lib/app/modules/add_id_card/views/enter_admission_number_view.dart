import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:citron_id_card/app/modules/add_id_card/controllers/add_id_card_controller.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/app_buttons.dart';
import '../../../core/components/app_textfield.dart';
import '../../../core/components/background_gradient.dart';
import '../../../core/components/two_line_element.dart';
import '../../../core/theme/app_colors.dart';

class EnterAdmissionNumberView extends GetView<AddIdCardController> {
  const EnterAdmissionNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                "\"\" Enter the student Admission/Registration No to view the student Details \"\"",
                style: AppTextStyle.title.medium.bold.textColor,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                color: AppColors.textOnGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TwoLineElement(
                    title: "Admission/Reg. No",
                    child: AppTextField(
                      hintText: "Enter admission/reg. number",
                      controller: controller.admissionController,
                    ),
                  ),
                  SizedBox(height: 10),
                  AppButton(
                    width: 140,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                    textColor: AppColors.generateGradientColors().first,
                    text: "Submit",
                    onPressed: () {
                      Get.toNamed(AppRoutes.addIdCard);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
