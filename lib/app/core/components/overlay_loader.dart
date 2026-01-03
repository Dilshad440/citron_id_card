import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../theme/app_colors.dart';

class OverlayIdCardLoader extends StatelessWidget {
  const OverlayIdCardLoader({
    super.key,
    required this.child,
    required this.isLoading,
  });

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OverlayLoaderWithAppIcon(
      isLoading: isLoading,
      overlayOpacity: 0.3,
      overlayBackgroundColor: AppColors.generateGradientColors().last,
      appIcon: SpinKitWaveSpinner(
        color: AppColors.generateGradientColors().last,
      ),
      child: isLoading ? SizedBox() : child,
    );
  }
}
