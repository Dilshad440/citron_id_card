import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/core/theme/app_colors.dart';
import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:citron_id_card/app/modules/school/id_card/views/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              child: Text(
                "No data found !!",
                style: AppTextStyle.title.medium.regular,
              ),
            ),
          ),
        );
      }

      if (controller.isParent.value) {
        return EnterAdmissionNumberView();
      }
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
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackgroundGradient(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: schoolUser?.logo != null
                        ? NetworkImage(schoolUser!.logo!)
                        : null,
                    child: schoolUser?.logo == null
                        ? const Icon(Icons.school, size: 30, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // School Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // School Name
                        Text(
                          schoolUser?.schoolName ?? "",
                          style: AppTextStyle.title.medium.bold.textColor,
                        ),
                        const SizedBox(height: 6),

                        // Address
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: AppColors.textOnGradient,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                schoolUser?.address1 ?? "",
                                style: AppTextStyle
                                    .title
                                    .medium
                                    .regular
                                    .semiBold
                                    .textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Contact
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 20,
                              color: AppColors.textOnGradient,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              schoolUser?.contactNo ?? "",
                              style:
                                  AppTextStyle.title.medium.regular.textColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Email
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 20,
                              color: AppColors.textOnGradient,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              schoolUser?.email ?? "",
                              style:
                                  AppTextStyle.title.medium.regular.textColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Website
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 20,
                              color: AppColors.textOnGradient,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              schoolUser?.website ?? "",
                              style:
                                  AppTextStyle.title.medium.regular.textColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton.filled(
          onPressed: () {
            homeController.logout();
          },
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }
}
