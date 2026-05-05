import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/components/app_date_picker.dart';
import 'package:citron_id_card/app/core/components/app_dropdown.dart';
import 'package:citron_id_card/app/core/components/app_textfield.dart';
import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/core/components/overlay_loader.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:citron_id_card/app/core/theme/app_colors.dart';
import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/final%20_field_model.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/get_sessions.dart';
import 'package:citron_id_card/app/modules/shared/home/views/home_view.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/GetFiledElements.dart';
import '../../../shared/home/controllers/home_controller.dart';

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Scaffold(
      body: BackgroundGradient(
        child: Obx(
          () => OverlayIdCardLoader(
            isLoading: homeController.isOverlayLoading.value,
            child: (isLoading) {
              return ListView(
                children: [
                  SchoolInfoCard(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Filter", style: AppTextStyle.display.medium),
                      Spacer(),
                      (homeController.schoolUser.value?.canAdd ?? false)
                          ? SizedBox(
                              height: 35,
                              child: FloatingActionButton.extended(
                                backgroundColor: AppColors.textOnGradient,
                                tooltip: "Add New Student",
                                extendedIconLabelSpacing: 5,
                                isExtended: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                icon: Icon(
                                  Icons.add,
                                  color:
                                      AppColors.generateGradientColors().last,
                                  size: 25,
                                ),
                                label: Text(
                                  "Add Student",
                                  style: AppTextStyle.body.medium.textColor,
                                ),
                                onPressed: () {
                                  Get.toNamed(AppRoutes.addIdCard);
                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(height: 15),
                  Form(
                    key: homeController.formKey,
                    child: Column(
                      children: [
                        TwoLineElement(
                          title: "Select batch",
                          child: AppDropdown(
                            hintText: "Select your batch",
                            items: homeController.batch,
                            value: homeController.selectedBatch,
                            validator: (value) {
                              if (value == null) {
                                return "Select your session";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              homeController.selectedBatch = value;
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        TwoLineElement(
                          title: "Select session",
                          child: GetBuilder<HomeController>(
                            id: "class",
                            builder: (controller) {
                              return AppDropdown<String>(
                                hintText: "Select your session",
                                items: homeController.sessions
                                    .map((e) => e.session ?? "")
                                    .toList(),
                                value: homeController.selectedSession,
                                validator: (value) {
                                  if (value == null) {
                                    return "Select your session";
                                  }
                                  return null;
                                },
                                onChanged: (value) async {
                                  homeController.selectedSession = value;
                                  final hasClassAndSection =
                                      homeController.fieldModel.any(
                                        (f) => f.title.toLowerCase() == "class",
                                      ) &&
                                      homeController.fieldModel.any(
                                        (f) =>
                                            f.title.toLowerCase() == "section",
                                      );
                                  if (hasClassAndSection) {
                                    await homeController.getClassAndSection(
                                      value!,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        ...homeController.fieldModel.map(
                          (element) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: GetBuilder<HomeController>(
                              id: "class",
                              builder: (controller) {
                                return GetFieldElements(
                                  isFromAddEdit: false,
                                  fieldModel: element,
                                  onChanged: (value, fieldName) {
                                    element.changedValue = value;
                                    element.controller.text = value!;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    text: "Filter",
                    onPressed: () {
                      homeController.getFilterResponse();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
