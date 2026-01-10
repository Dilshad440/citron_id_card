import 'package:flutter/material.dart';

import '../controllers/add_id_card_controller.dart';

typedef FieldValidator = String? Function(String? value);

class IdCardFieldModel {
  final String title;
  final String hint;
  final TextEditingController controller;
  final FieldValidator validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isObsecure;
  final GlobalKey fieldKey;

  IdCardFieldModel({
    required this.title,
    required this.hint,
    required this.controller,
    required this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.isObsecure = false,
    required this.fieldKey,
  });
}
