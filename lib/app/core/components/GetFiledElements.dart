import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/school/id_card/model/final _field_model.dart';
import '../../modules/shared/home/controllers/home_controller.dart';
import 'app_date_picker.dart';
import 'app_dropdown.dart';
import 'app_textfield.dart';

class GetFieldElements extends StatelessWidget {
  const GetFieldElements({
    super.key,
    required this.fieldModel,
    required this.onChanged,
    required this.isFromAddEdit,
  });

  final FieldModel fieldModel;
  final void Function(dynamic value, String fieldName) onChanged;
  final bool isFromAddEdit;

  @override
  Widget build(BuildContext context) {
    if (fieldModel.type == FieldType.dropdown && isFromAddEdit) {
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppTextField(
          keyboardType: TextInputType.text,
          controller: fieldModel.controller,
          hintText: "Enter ${fieldModel.title}",
          validator: fieldModel.validator,
        ),
      );
    }
    if (fieldModel.type == FieldType.dropdown) {
      final bool isClass = fieldModel.title.toLowerCase() == "class";
      final bool isSection = fieldModel.title.toLowerCase() == "section";
      final items = isClass
          ? Get.find<HomeController>().classList
          : Get.find<HomeController>().sectionList;

      final value = isClass || isSection ? "All" : fieldModel.changedValue;
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppDropdown<String>(
          hintText: fieldModel.hint,
          value: value,
          items: items,
          validator: fieldModel.validator,
          onChanged: (value) =>
              onChanged.call(value, fieldModel.title.toLowerCase()),
        ),
      );
    } else if (fieldModel.type == FieldType.textField) {
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppTextField(
          keyboardType: TextInputType.text,
          controller: fieldModel.controller,
          hintText: fieldModel.hint,
          validator: fieldModel.validator,
        ),
      );
    } else if (fieldModel.type == FieldType.numeric) {
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppTextField(
          keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),
          controller: fieldModel.controller,
          hintText: fieldModel.hint,
          validator: fieldModel.validator,
        ),
      );
    } else if (fieldModel.type == FieldType.datePicker &&
        fieldModel.enforcementType == false) {
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppTextField(
          keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),
          controller: fieldModel.controller,
          hintText: fieldModel.hint,
          validator: fieldModel.validator,
        ),
      );
    } else if (fieldModel.type == FieldType.datePicker &&
        fieldModel.enforcementType == true) {
      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppDatePickerField(
          hintText: fieldModel.hint,
          controller: fieldModel.controller,
          onDateSelected: (date) {
            fieldModel.changedValue = date;
          },
          validator: fieldModel.validator,
        ),
      );
    }
    return const Placeholder();
  }
}
