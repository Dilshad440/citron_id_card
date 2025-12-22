import 'package:flutter/material.dart';

import '../theme/app_text_style.dart';

class TwoLineElement extends StatelessWidget {
  const TwoLineElement({
    super.key,
    required this.title,
    required this.child,
    this.isRequired = true,
  });

  final String title;
  final Widget child;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyle.body.small.textColor.bold.italic.textHeight(
                1.5,
              ),
            ),
            if (isRequired) ...[
              Text(" *", style: AppTextStyle.title.medium.red.textHeight(0)),
            ],
          ],
        ),
        child,
      ],
    );
  }
}
