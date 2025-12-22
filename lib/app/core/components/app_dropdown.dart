import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.validator,
    this.prefix,
    this.maxHeight = 220,
  });

  final List<T> items;
  final T? value;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final double maxHeight;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: value,
      isExpanded: true,
      isDense: true,
      validator: validator,
      onChanged: onChanged,

      /// SAME text style as AppTextField input
      style: AppTextStyle.body.medium.textColor.medium,

      decoration: InputDecoration(
        prefixIcon: prefix,
        filled: true,
        fillColor: AppColors.borderColor.withOpacity(0.9),

        isDense: true,
        counter: const SizedBox.shrink(),

        /// EXACT SAME padding as AppTextField
        contentPadding: const EdgeInsets.symmetric(vertical: 1),

        labelText: labelText,
        labelStyle: AppTextStyle.title.small.mutedTextColor.regular,
        errorStyle: AppTextStyle.body.small.red.regular,

        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.primaryColor, width: 1.3),
        errorBorder: _border(color: Colors.red),
        focusedErrorBorder: _border(color: Colors.red, width: 1.3),
      ),

      /// 🔥 HINT (style FIXED & aligned)
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hintText ?? '',
          style: AppTextStyle.body.small.mutedTextColor.regular,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      /// 🔥 SELECTED VALUE (style LOCKED)
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.toString(),
              style: AppTextStyle.body.small.textColor.medium,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },

      /// Dropdown items
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString(),
                style: AppTextStyle.body.medium.textColor.medium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),

      /// Dropdown popup styling
      dropdownStyleData: DropdownStyleData(
        maxHeight: maxHeight,
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 8,
      ),

      /// SAME density as textfield
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),

      /// SAME height as AppTextField
      buttonStyleData: const ButtonStyleData(
        height: 40,
        padding: EdgeInsets.zero,
      ),

      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 22,
      ),
    );
  }

  OutlineInputBorder _border({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: (color ?? AppColors.primaryColor).withOpacity(0.6),
        width: width,
      ),
    );
  }
}
