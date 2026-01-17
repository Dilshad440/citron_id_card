import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/components/app_dropdown.dart';
import 'package:citron_id_card/app/core/components/app_textfield.dart';
import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/core/components/overlay_loader.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:citron_id_card/app/core/theme/app_colors.dart';
import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/final%20_field_model.dart';
import 'package:citron_id_card/app/modules/shared/home/views/home_view.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                              return AppDropdown(
                                hintText: "Select your session",
                                items: homeController.session,
                                value: homeController.selectedSession,
                                validator: (value) {
                                  if (value == null) {
                                    return "Select your session";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  homeController.selectedSession = value;
                                  homeController.getClassAndSection(value!);
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
                                return _GetFieldElements(
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

class _GetFieldElements extends StatelessWidget {
  const _GetFieldElements({
    super.key,
    required this.fieldModel,
    required this.onChanged,
  });

  final FieldModel fieldModel;
  final void Function(dynamic value, String fieldName) onChanged;

  @override
  Widget build(BuildContext context) {
    if (fieldModel.type == FieldType.dropdown) {
      final bool isClass = fieldModel.title.toLowerCase() == "class";
      final bool isSection = fieldModel.title.toLowerCase() == "section";
      final items = isClass
          ? Get.find<HomeController>().classList
          : Get.find<HomeController>().sectionList;

      final value = isClass || isSection ? "All" : fieldModel.changedValue;
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: true,
        child: AppDropdown<String>(
          hintText: fieldModel.hint,
          value: value,
          items: items,
          // validator: fieldModel.validator,
          onChanged: (value) =>
              onChanged.call(value, fieldModel.title.toLowerCase()),
        ),
      );
    } else if (fieldModel.type == FieldType.textField) {
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: false,
        child: AppTextField(
          controller: fieldModel.controller,
          hintText: fieldModel.hint,
          // validator: fieldModel.validator,
        ),
      );
    }
    return const Placeholder();
  }
}
