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

class AddIdCardView extends GetView<AddIdCardController> {
  const AddIdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(title: "Add Student"),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TwoLineElement(title: "Student Name", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Father Name", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Mother Name", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "D.O.B", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Mobile", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Address", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Class/Course/Sem", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Section/Branch/Stream", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Email Id", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Aadhaar No.", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "PAN No.", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Session.", child: AppTextField()),
          SizedBox(height: 8),
          TwoLineElement(title: "Batch.", child: AppTextField()),
          SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.teal),
            ),
            child: Obx(() {
              if (controller.selectedImage.value != null) {
                return Image.file(controller.selectedImage.value!);
              }
              return Column(
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
              );
            }),
          ),

          SizedBox(height: 15),
          AppButton(text: "Submit", onPressed: () {}),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
