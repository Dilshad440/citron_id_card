import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/config/network/api_constants.dart';
import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/core/theme/app_colors.dart';
import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:citron_id_card/app/core/utils/common_utils.dart';
import 'package:citron_id_card/app/modules/school/id_card/views/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../main.dart';
import '../../../parent/add_id_card/views/enter_admission_number_view.dart';
import '../../../school/id_card/views/id_card_view.dart';
import '../controllers/home_controller.dart';
import '../model/school_user_res.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: BackgroundGradient(
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      if (!controller.isLoading.value && controller.schoolUser.value == null) {
        return Scaffold(
          body: BackgroundGradient(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No data found !!",
                    style: AppTextStyle.title.medium.regular,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      controller.getSchoolUserRes();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "Refresh",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // if (controller.isParent.value) {
      //   return EnterAdmissionNumberView();
      // }
      return FilterView();
    });
  }
}

class SchoolInfoCard extends StatelessWidget {
  const SchoolInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final schoolUser = homeController.schoolUser.value;

    return Stack(
      children: [
        // Main Card
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackgroundGradient(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // School Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // School Logo
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: schoolUser?.logo != null
                            ? NetworkImage(
                                '${ApiConstants.baseUrl}${schoolUser!.logo!}',
                              )
                            : null,
                        child: schoolUser?.logo == null
                            ? const Icon(
                                Icons.school_rounded,
                                size: 30,
                                color: Colors.grey,
                              )
                            : null,
                      ),

                      const SizedBox(width: 15),

                      // School Name
                      Expanded(
                        child: Padding(
                          // Space for Settings + Logout buttons
                          padding: const EdgeInsets.only(right: 85),
                          child: Text(
                            schoolUser?.schoolName ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.display.medium.bold.textColor
                                .copyWith(fontSize: 24, height: 1.2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Address
                  _infoRow(
                    icon: Icons.location_on_rounded,
                    value: schoolUser?.address1,
                    semiBold: true,
                  ),

                  const SizedBox(height: 6),

                  // Contact
                  _infoRow(
                    icon: Icons.phone_rounded,
                    value: schoolUser?.contactNo,
                  ),

                  const SizedBox(height: 6),

                  // Email
                  _infoRow(icon: Icons.email_rounded, value: schoolUser?.email),

                  const SizedBox(height: 6),

                  // Website
                  _infoRow(
                    icon: Icons.link_rounded,
                    value: schoolUser?.website,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Top Right Actions
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Settings
              IconButton.filled(
                onPressed: () async {
                  final quality = await CommonUtils.showCompressionDialog();
                  if (quality == null) return;
                  await SharedPrefs.instance.setString(
                    AppConstants.compressQuality,
                    quality.name,
                  );
                },
                icon: const Icon(Icons.settings_rounded, size: 20),
              ),

              const SizedBox(width: 5),

              // Logout
              IconButton.filled(
                onPressed: () {
                  homeController.logout();
                },
                icon: const Icon(Icons.logout_rounded, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String? value,
    bool semiBold = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColors.textOnGradient),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: semiBold
                ? AppTextStyle.title.medium.regular.semiBold.textColor
                : AppTextStyle.title.medium.regular.textColor,
          ),
        ),
      ],
    );
  }
}
