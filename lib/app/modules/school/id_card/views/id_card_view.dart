import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/core/components/overlay_loader.dart';
import 'package:citron_id_card/app/core/utils/common_utils.dart';
import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/id_card_controller.dart';
import '../model/student_id_model.dart';

class IdCardView extends GetView<IdCardController> {
  const IdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  "Student Id Card",
                  style: AppTextStyle.title.large.textColor,
                ),
              ],
            ),
            Expanded(
              child: GetBuilder<IdCardController>(
                id: "idCard",
                builder: (controller) {
                  return OverlayIdCardLoader(
                    isLoading: controller.isLoading.value,
                    child: (isLoading) {
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!isLoading && controller.schoolIds == null) {
                        return const Center(child: Text("No Data Found"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.schoolIds?.length,
                        itemBuilder: (_, index) {
                          final students = controller.schoolIds?[index];
                          return _StudentIdCard(
                            student: students,
                            onEdit: () {},
                            onDelete: () {},
                            onExpand: (val) =>
                                controller.expandCard(index, val),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentIdCard extends GetView<IdCardController> {
  const _StudentIdCard({
    this.student,
    required this.onEdit,
    required this.onDelete,
    required this.onExpand,
  });

  final Records? student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool val) onExpand;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        color: AppColors.generateGradientColors().first,
        // gradient: LinearGradient(
        //   colors: AppColors.generateGradientColors(),
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// 🔹 HEADER
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  // gradient: LinearGradient(
                  //   colors: AppColors.generateGradientColors(),
                  //   end: Alignment.topRight,
                  //   begin: Alignment.topLeft,
                  // ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Get.find<HomeController>().schoolUser.value?.schoolName ??
                          "",
                      style: AppTextStyle.title.medium.textColor.bold,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Edit',
                      style: AppTextStyle.title.medium.primaryColor,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: AppTextStyle.title.medium.red),
                  ),
                ],
              ),
            ],
          ),

          /// 🔹 STUDENT DETAILS
          ExpansionTile(
            showTrailingIcon: false,
            onExpansionChanged: onExpand,
            initiallyExpanded: student?.isExpanded ?? false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// PHOTO
                if (student?.isExpanded ?? false) ...[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GetBuilder<IdCardController>(
                        id: "photo",
                        builder: (controller) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryColor.withOpacity(
                              0.3,
                            ),
                            backgroundImage: controller.selectedImg != null
                                ? FileImage(controller.selectedImg!)
                                : NetworkImage(student?.photo ?? ""),
                          );
                        },
                      ),

                      // Edit Icon
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: InkWell(
                          onTap: () {
                            controller.pickImage(student!.id!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  AppTextStyle.body.large.textColor.bold.text(
                    'Admission: ${student?.data?.admNo}',
                  ),
                  const SizedBox(height: 4),
                  AppTextStyle.body.medium.textColor.bold.text(
                    'Class: ${student?.data?.clas}',
                  ),
                ] else ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          0.3,
                        ),
                        backgroundImage: NetworkImage(student?.photo ?? ""),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              "Admission No",
                              student?.data?.admNo ?? "",
                              bottomPadding: 0,
                            ),
                            _infoRow(
                              "Name",
                              student?.data?.studentName ?? "",
                              bottomPadding: 0,
                            ),
                            _infoRow(
                              "Class",
                              student?.data?.clas ?? "",
                              bottomPadding: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _infoRow('Name', student?.data?.studentName ?? ""),
                    // _infoRow('Mother', student.motherName),
                    _infoRow('D.O.B', "NA"),
                    _infoRow('Mobile', "NA"),
                    _infoRow('Conveyance', "NA"),
                    _infoRow('Address', "NA"),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  // gradient: LinearGradient(
                  //   colors: AppColors.generateGradientColors(),
                  //   end: Alignment.topLeft,
                  //   begin: Alignment.topRight,
                  // ),
                  borderRadius: const BorderRadius.vertical(
                    // top: Radius.circular(18),
                    bottom: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "School Information like mobile, address, website here...",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.title.small.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {double bottomPadding = 6.0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: AppTextStyle.body.small.textColor.semiBold.text(label),
          ),
          SizedBox(
            width: 20,
            child: AppTextStyle.body.small.textColor.semiBold.text(":"),
          ),

          Flexible(
            child: AppTextStyle.body.small.textColor.semiBold.text(value),
          ),
        ],
      ),
    );
  }
}
