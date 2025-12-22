import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor = AppColors.teal,
    this.centerTile = true,
  });

  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      backgroundColor: backgroundColor,
      centerTitle: centerTile,
      title: Text(title, style: AppTextStyle.title.large.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
