import 'package:flutter/material.dart';

import '../controllers/add_id_card_controller.dart';

typedef FieldValidator = String? Function(String?);

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

  static List<IdCardFieldModel> getFields(AddIdCardController c) {
    return [
      IdCardFieldModel(
        title: "Student Name",
        hint: "Enter student name",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Student name"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Father Name",
        hint: "Enter father name",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Father name"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Mother Name",
        hint: "Enter mother name",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Mother name"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "D.O.B",
        hint: "Select date of birth",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Date of birth"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Mobile",
        hint: "Enter mobile number",
        controller: TextEditingController(),
        keyboardType: TextInputType.phone,
        validator: c.mobileValidator,
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Address",
        hint: "Enter address",
        controller: TextEditingController(),
        maxLines: 2,
        validator: (v) => c.requiredValidator(v, "Address"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Class/Course/Sem",
        hint: "Enter class / course / semester",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Class / Course / Semester"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Section/Branch/Stream",
        hint: "Enter section / branch / stream",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Section / Branch / Stream"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Email Id",
        hint: "Enter email id",
        controller: TextEditingController(),
        keyboardType: TextInputType.emailAddress,
        validator: c.emailValidator,
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Aadhaar No.",
        hint: "Enter Aadhaar number",
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
        validator: c.aadhaarValidator,
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "PAN No.",
        hint: "Enter PAN number",
        controller: TextEditingController(),
        validator: c.panValidator,
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Session",
        hint: "Enter session",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Session"),
        fieldKey: GlobalKey(),
      ),
      IdCardFieldModel(
        title: "Batch",
        hint: "Enter batch",
        controller: TextEditingController(),
        validator: (v) => c.requiredValidator(v, "Batch"),
        fieldKey: GlobalKey(),
      ),
    ];
  }
}
