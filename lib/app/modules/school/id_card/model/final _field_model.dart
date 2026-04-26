import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import '../../../parent/add_id_card/model/id_card_field_model.dart';

enum FieldType { dropdown, numeric,textField, datePicker, timePicker, checkbox }

class FieldModel {
  final String title;
  final String hint;
  final bool isRequired;
  final bool enforcementType;
  dynamic changedValue;
  final List<String>? items;

  final FieldType type;

  final TextEditingController controller;

  final FieldValidator validator;
  final TextInputType keyboardType;

  FieldModel({
    required this.title,
    required this.hint,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    required this.type,
    this.changedValue,
    this.items,
    required this.enforcementType,
    required this.isRequired
  });

  static List<FieldModel> getStaticFields(HomeController c) {
    return [
      FieldModel(
          title: "Batch",
          hint: "Select batch",
          items: c.batch,
          controller: TextEditingController(),
          validator: (value) => value == null ? "Select batch" : null,
          keyboardType: TextInputType.text,
          type: FieldType.dropdown,
          enforcementType: false,
          isRequired: false,
      ),
    ];
  }
}
