import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/components/app_textfield.dart';
import 'package:citron_id_card/app/core/components/common_appbbar.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:citron_id_card/app/core/constant/asset_constant.dart';
import 'package:citron_id_card/app/core/theme/app_colors.dart';
import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:citron_id_card/app/core/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_id_card_controller.dart';
import '../model/id_card_field_model.dart';

class AddIdCardView extends GetView<AddIdCardController> {
  const AddIdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterDecoration: BoxDecoration(
        color: AppColors.generateGradientColors().last,
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppButton(
            text: "Submit",
            onPressed: () {
              final fields = IdCardFieldModel.getFields(controller);

              final isValid = controller.formKey.currentState!.validate();
              if (isValid) {
                print("API call");
                return;
              }

              // 🔥 WAIT for validation UI to render
              WidgetsBinding.instance.addPostFrameCallback((_) {
                for (final field in fields) {
                  final error = field.validator?.call(field.controller.text);
                  if (error != null) {
                    final context = field.fieldKey.currentContext;
                    if (context != null) {
                      Scrollable.ensureVisible(
                        context,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        alignment: 0.2, // keeps field slightly below top
                      );
                    }
                    break;
                  }
                }
              });
            },

          ),
        ),
      ],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.generateGradientColors(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Student Id Card",
                    style: AppTextStyle.title.large.textColor,
                  ),
                ],
              ),
              Expanded(
                child: Form(
                  key: controller.formKey,
                  child: ListView(
                    controller: controller.scrollController,

                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    children: [
                      ...IdCardFieldModel.getFields(controller)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: TwoLineElement(
                                title: e.title,
                                child: AppTextField(
                                  hintText: e.hint,
                                  validator: e.validator,
                                  controller: e.controller,
                                  key: e.fieldKey,
                                ),
                              ),
                            ),
                          )
                          .toList(),

                      SizedBox(height: 12),
                      GetBuilder<AddIdCardController>(
                        id: controller.builderId,
                        builder: (controller) {
                          return _ImageCard(controller: controller);
                          ;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({super.key, required this.controller});

  final AddIdCardController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Image.file(controller.selectedImage!, fit: BoxFit.fill),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: () {
                controller.removePickedImage();
              },
              icon: Icon(Icons.delete, color: AppColors.textOnGradient),
            ),
          ],
        ),
      );
    }
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.generateGradientColors().first.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetConstant.uploadImage, height: 80),
          SizedBox(height: 15),
          AppButton(
            width: 150,
            text: "Upload Photo",
            onPressed: () {
              controller.selectImage();
            },
          ),
        ],
      ),
    );
  }
}
