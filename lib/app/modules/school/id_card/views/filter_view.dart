import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/components/app_dropdown.dart';
import 'package:citron_id_card/app/core/components/app_textfield.dart';
import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
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
        child: ListView(
          children: [
            SchoolInfoCard(),
            SizedBox(height: 20),
            Text("Filter", style: AppTextStyle.display.medium),
            Form(
              key: homeController.formKey,
              child: Column(
                children: homeController.fieldModel
                    .map(
                      (element) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _GetFieldElements(fieldModel: element),
                      ),
                    )
                    .toList(),
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
        ),
      ),
    );
  }
}

class _GetFieldElements extends StatelessWidget {
  const _GetFieldElements({super.key, required this.fieldModel});

  final FieldModel fieldModel;

  @override
  Widget build(BuildContext context) {
    if (fieldModel.type == FieldType.dropdown) {
      return TwoLineElement(
        title: fieldModel.title,
        child: AppDropdown<String>(
          hintText: fieldModel.hint,
          value: fieldModel.changedValue,
          items: fieldModel.items ?? [],
          validator: fieldModel.validator,
          onChanged: (value) {
            fieldModel.changedValue = value;
            fieldModel.controller.text = value!;
          },
        ),
      );
    } else if (fieldModel.type == FieldType.textField) {
      return TwoLineElement(
        title: fieldModel.title,
        child: AppTextField(
          controller: fieldModel.controller,
          hintText: fieldModel.hint,
          validator: fieldModel.validator,
        ),
      );
    }
    return const Placeholder();
  }
}
