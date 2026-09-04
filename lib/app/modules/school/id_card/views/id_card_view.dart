import 'dart:io';
import 'package:citron_id_card/app/config/network/api_constants.dart';
import 'package:citron_id_card/app/core/components/background_gradient.dart';
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
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  "Student Id Card",
                  style: AppTextStyle.title.large.textColor,
                ),
                const Spacer(),
                GetBuilder<IdCardController>(
                  id: "idCard",
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: '${controller.schoolIds?.length ?? 0} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: controller.schoolIds?.length == 1
                                    ? 'card found'
                                    : 'cards found',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: GetBuilder<IdCardController>(
                id: "idCard",
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!controller.isLoading.value &&
                      controller.schoolIds == null) {
                    return const Center(child: Text("No data found!!!"));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.schoolIds?.length,
                      itemBuilder: (_, index) {
                        final students = controller.schoolIds?[index];
                        return _StudentIdCard(
                          student: students,
                          index: index,
                          onEdit: (std) async {
                            if (std == null) return;
                            final result = await Get.toNamed(
                              AppRoutes.addIdCard,
                              arguments: std,
                            );
                            if (result == true) {
                              controller.getIdCards();
                            }
                          },
                          onDelete: (std) async {
                            controller.deleteIdCard(std!.id!);
                          },
                          onExpand: (val) => controller.expandCard(index, val),
                        );
                      },
                    ),
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
    required this.index,
  });

  final StudentIdModel? student;
  final void Function(StudentIdModel? student) onEdit;
  final void Function(StudentIdModel? student) onDelete;
  final Function(bool val) onExpand;
  final int index;

  /// Helper to extract non-null/non-empty entries in exact API sequence
  List<MapEntry<String, dynamic>> _getValidEntries(Map<String, dynamic>? json) {
    if (json == null) return [];
    return json.entries.where((e) {
      final value = e.value?.toString().trim();
      return value != null && value.isNotEmpty && value.toLowerCase() != 'null';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final schoolUser = Get.find<HomeController>().schoolUser.value;
    final validEntries = _getValidEntries(student?.data?.toJson());

    return GestureDetector(
      onTap: () => onExpand.call(student?.isExpanded ?? false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          color: AppColors.generateGradientColors().first,
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
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        schoolUser?.schoolName ?? "",
                        style: AppTextStyle.title.medium.textColor.bold,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit.call(student);
                    } else if (value == 'delete') {
                      onDelete.call(student);
                    }
                  },
                  itemBuilder: (context) => [
                    if (schoolUser?.canEdit ?? false) ...[
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'Edit',
                          style: AppTextStyle.title.medium.primaryColor,
                        ),
                      ),
                    ],
                    if (schoolUser?.canDelete ?? false) ...[
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: AppTextStyle.title.medium.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (student?.isExpanded ?? false) ...[
                  /// Expanded View (Top 2 entries under Avatar in API sequence)
                  _ExpandedView(
                    index: index,
                    student: student,
                    validEntries: validEntries,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Remaining entries in API sequence
                        ...validEntries.skip(2).map((e) {
                          return _infoRow(
                            label: e.key,
                            value: e.key.toLowerCase() == "dob"
                                ? CommonUtils.formatDateForUI(
                                    e.value.toString(),
                                  )
                                : e.value.toString(),
                            bottomPadding: 0,
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GetBuilder<HomeController>(
                            builder: (controller) {
                              final currentSchoolUser =
                                  controller.schoolUser.value;
                              return Column(
                                children: [
                                  Text(
                                    [
                                          currentSchoolUser?.address1,
                                          currentSchoolUser?.address2,
                                          currentSchoolUser?.address3,
                                        ]
                                        .where(
                                          (e) =>
                                              e != null && e.trim().isNotEmpty,
                                        )
                                        .join(', '),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.title.small.textColor,
                                  ),
                                  Text(
                                    "Mob: ${currentSchoolUser?.contactNo?.trim().isNotEmpty == true ? currentSchoolUser!.contactNo : 'NA'}",
                                    style: AppTextStyle
                                        .body
                                        .small
                                        .semiBold
                                        .italic
                                        .copyWith(fontSize: 13),
                                  ),
                                  Text(
                                    "Website: ${currentSchoolUser?.website?.trim().isNotEmpty == true ? currentSchoolUser!.website : 'NA'}",
                                    style: AppTextStyle
                                        .body
                                        .small
                                        .semiBold
                                        .italic
                                        .copyWith(
                                          color: AppColors.textOnGradient,
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  /// Collapsed View (Top 3 entries in exact API sequence)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        UserAvatar(
                          file: student?.selectedImg,
                          imageUrl: student?.photo,
                          radius: 35,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: validEntries.take(3).map((e) {
                              return _infoRow(
                                label: e.key,
                                value: e.key.toLowerCase() == "dob"
                                    ? CommonUtils.formatDateForUI(
                                        e.value.toString(),
                                      )
                                    : e.value.toString(),
                                bottomPadding: 0,
                                width: Get.size.width * 0.25,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedView extends GetView<IdCardController> {
  const _ExpandedView({
    this.student,
    required this.index,
    required this.validEntries,
  });

  final StudentIdModel? student;
  final int index;
  final List<MapEntry<String, dynamic>> validEntries;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            UserAvatar(
              radius: 45,
              iconSize: 60,
              imageUrl: student?.photo,
              file: student?.selectedImg,
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: InkWell(
                onTap: () {
                  controller.pickImage(student!.id!, index);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: validEntries.take(2).map((e) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      child: AppTextStyle.body.large.textColor.bold.ellipsis
                          .text('${e.key}  '),
                    ),
                    Expanded(
                      child: AppTextStyle.body.large.textColor.bold.ellipsis.text(
                        ':    ${e.key.toLowerCase() == "dob" ? CommonUtils.formatDateForUI(e.value.toString()) : e.value.toString()}',
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class UserAvatar extends StatelessWidget {
  final File? file;
  final String? imageUrl;
  final double radius;
  final double? iconSize;

  const UserAvatar({
    super.key,
    this.file,
    this.imageUrl,
    this.radius = 35,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.generateGradientColors().last.withOpacity(0.7),
        ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (file != null) {
      return ClipOval(child: Image.file(file!, fit: BoxFit.cover));
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          "${ApiConstants.baseUrl}${imageUrl!}",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderIcon();
          },
        ),
      );
    }

    return _placeholderIcon();
  }

  Widget _placeholderIcon() {
    return ClipOval(
      child: Center(
        child: Icon(
          Icons.person,
          size: iconSize,
          color: AppColors.generateGradientColors().first,
        ),
      ),
    );
  }
}

Widget _infoRow({
  required String label,
  required String value,
  double bottomPadding = 6.0,
  double? width,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width ?? Get.size.width * 0.35,
          child: AppTextStyle.body.small.textColor.semiBold.text(label),
        ),
        SizedBox(
          width: 20,
          child: AppTextStyle.body.small.textColor.semiBold.text(":"),
        ),
        Flexible(child: AppTextStyle.body.small.textColor.semiBold.text(value)),
      ],
    ),
  );
}
