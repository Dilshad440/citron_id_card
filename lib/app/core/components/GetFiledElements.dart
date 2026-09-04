import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/core/components/two_line_element.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../modules/school/id_card/model/final _field_model.dart';
import '../../modules/shared/home/controllers/home_controller.dart';
import '../utils/text_case_formatter.dart';
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
    if (fieldModel.type == FieldType.list) {
      final items = List<String>.from(
        fieldModel.dropdownList[fieldModel.title]!,
        growable: true,
      );

      return TwoLineElement(
        title: fieldModel.title,
        isRequired: fieldModel.isRequired,
        child: AppDropdown<String>(
          hintText: fieldModel.hint,
          value: fieldModel.changedValue,
          items: items,
          isSearchable: items.length > 3,
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
          textCapitalization: getTextCapitalisation(),
          inputFormatters: getInputFormatters(),
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
          keyboardType: const TextInputType.numberWithOptions(
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
          currentDate: DateTime.tryParse(fieldModel.controller.text),
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

  // ----------------------------------------------------------
  // Text Capitalisation
  // ----------------------------------------------------------

  TextCapitalization getTextCapitalisation() {
    final textCase = Get.find<HomeController>().schoolUser.value?.textCase
        ?.toLowerCase();

    switch (textCase) {
      case 'propercase':
        return TextCapitalization.words;

      case 'uppercase':
        return TextCapitalization.characters;

      case 'lowercase':
        return TextCapitalization.none;

      default:
        return TextCapitalization.none;
    }
  }

  // ----------------------------------------------------------
  // Input Formatters
  // ----------------------------------------------------------

  List<TextInputFormatter>? getInputFormatters() {
    final textCase = Get.find<HomeController>().schoolUser.value?.textCase
        ?.toLowerCase();

    switch (textCase) {
      case 'propercase':
        return [ProperCaseFormatter()];

      case 'uppercase':
        return [UpperCaseFormatter()];

      case 'lowercase':
        return [LowerCaseFormatter()];

      default:
        return null;
    }
  }
}
