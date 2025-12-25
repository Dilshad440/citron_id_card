import 'package:citron_id_card/app/core/components/background_gradient.dart';
import 'package:citron_id_card/app/modules/id_card/controllers/id_card_controller.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../model/student_id_model.dart';

class IdCardView extends GetView<IdCardController> {
  const IdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CommonAppBar(
      //   title: 'Student ID Cards',
      //   backgroundColor: AppColors.primaryColor,
      // ),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.idCards?.length,
                    itemBuilder: (_, index) {
                      final students = controller.idCards?[index];
                      return _StudentIdCard(
                        student: students!,
                        onEdit: () {},
                        onDelete: () {},
                        onExpand: (val) => controller.expandCard(index, val),
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

class _StudentIdCard extends StatelessWidget {
  const _StudentIdCard({
    required this.student,
    required this.onEdit,
    required this.onDelete,
    required this.onExpand,
  });

  final StudentIdModel student;
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
                      "Canossa Ayodhya English School",
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
            initiallyExpanded: student.isExpanded,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// PHOTO
                if (student.isExpanded) ...[
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                    backgroundImage: NetworkImage(student.photoUrl),
                  ),
                  const SizedBox(width: 14),
                  AppTextStyle.body.large.textColor.bold.text(
                    'Admission: ${student.admissionNo}',
                  ),
                  const SizedBox(height: 4),
                  AppTextStyle.body.medium.textColor.bold.text(
                    'Class: ${student.classSection}',
                  ),
                ] else ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          0.3,
                        ),
                        backgroundImage: NetworkImage(student.photoUrl),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              "Admission No",
                              student.admissionNo,
                              bottomPadding: 0,
                            ),
                            _infoRow(
                              "Name",
                              student.fatherName,
                              bottomPadding: 0,
                            ),
                            _infoRow(
                              "Class",
                              student.classSection,
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
                    _infoRow('Father', student.fatherName),
                    _infoRow('Mother', student.motherName),
                    _infoRow('D.O.B', student.dob),
                    _infoRow('Mobile', student.mobile),
                    _infoRow('Conveyance', student.conveyance),
                    _infoRow('Address', student.address),
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
