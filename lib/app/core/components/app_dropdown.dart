import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.searchHintText = 'Search...',
    this.isSearchable = false, // 👈 Optional flag (defaults to false)
    this.validator,
    this.prefix,
    this.maxHeight = 220,
    this.itemAsString,
  });

  final List<T> items;
  final T? value;
  final String? labelText;
  final String? hintText;
  final String searchHintText;
  final bool isSearchable;
  final Widget? prefix;
  final double maxHeight;
  final void Function(T? value) onChanged;
  final String? Function(T? value)? validator;

  /// Custom string conversion if T is an Object (defaults to item.toString())
  final String Function(T item)? itemAsString;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();
    if (widget.isSearchable) {
      _searchController = TextEditingController();
    }
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle toggling isSearchable dynamically if needed
    if (widget.isSearchable && _searchController == null) {
      _searchController = TextEditingController();
    } else if (!widget.isSearchable && _searchController != null) {
      _searchController?.dispose();
      _searchController = null;
    }
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  String _getItemLabel(T item) {
    if (widget.itemAsString != null) {
      return widget.itemAsString!(item);
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: widget.value,
      isExpanded: true,
      isDense: true,
      validator: widget.validator,
      onChanged: widget.onChanged,

      style: AppTextStyle.body.medium.textColor.medium,

      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        filled: true,
        fillColor: AppColors.borderColor.withOpacity(0.9),
        isDense: true,
        counter: const SizedBox.shrink(),
        contentPadding: const EdgeInsets.symmetric(vertical: 3),
        labelText: widget.labelText,
        labelStyle: AppTextStyle.title.small.mutedTextColor.regular,
        errorStyle: AppTextStyle.body.small.red.regular,
        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.primaryColor, width: 1.3),
        errorBorder: _border(color: Colors.red),
        focusedErrorBorder: _border(color: Colors.red, width: 1.3),
      ),

      /// Hint
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hintText ?? '',
          style: AppTextStyle.body.small.mutedTextColor.regular,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      /// Selected Value Display
      selectedItemBuilder: (context) {
        return widget.items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _getItemLabel(item),
              style: AppTextStyle.body.small.textColor.medium,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },

      /// Dropdown Items
      items: widget.items
          .map(
            (item) => DropdownMenuItem<T>(
          value: item,
          child: Text(
            _getItemLabel(item),
            style: AppTextStyle.body.small.textColor.medium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
          .toList(),

      /// Optional Search Configuration
      dropdownSearchData: widget.isSearchable && _searchController != null
          ? DropdownSearchData<T>(
        searchController: _searchController!,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _searchController,
            style: AppTextStyle.body.small.textColor.medium,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.searchHintText,
              hintStyle: AppTextStyle.body.small.mutedTextColor.regular,
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          if (item.value == null) return false;
          final itemString = _getItemLabel(item.value as T).toLowerCase();
          return itemString.contains(searchValue.toLowerCase().trim());
        },
      )
          : null,

      /// Clear search input when closed
      onMenuStateChange: (isOpen) {
        if (!isOpen && widget.isSearchable) {
          _searchController?.clear();
        }
      },

      /// Dropdown Popup Styling
      dropdownStyleData: DropdownStyleData(
        maxHeight: widget.maxHeight,
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 8,
      ),

      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),

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