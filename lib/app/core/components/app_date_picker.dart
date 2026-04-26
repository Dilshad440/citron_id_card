import 'package:citron_id_card/app/core/components/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDatePickerField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  /// ✅ Callback for selected DateTime
  final Function(DateTime date)? onDateSelected;

  const AppDatePickerField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.onDateSelected,
  });

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      /// ✅ UI value
      widget.controller.text = DateFormat('dd-MM-yyyy').format(picked);

      /// ✅ API / external value
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: widget.hintText,
      controller: widget.controller,
      validator: widget.validator,
      onTap: () => _pickDate(context),
      readOnly: true,
    );
    // return TextFormField(
    //   controller: widget.controller,
    //   readOnly: true,
    //   validator: widget.validator,
    //   onTap: () => _pickDate(context),
    //   decoration: InputDecoration(
    //     labelText: widget.label,
    //     hintText: widget.hintText,
    //     suffixIcon: const Icon(Icons.calendar_month),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );
  }
}
