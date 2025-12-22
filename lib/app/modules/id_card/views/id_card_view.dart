import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/common_appbbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../model/student_id_model.dart';

class IdCardView extends StatelessWidget {
  const IdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final students = <StudentIdModel>[
      StudentIdModel(
        admissionNo: 'A1023',
        fatherName: 'Mohd. Ali',
        motherName: 'Ayesha Ali',
        address: 'Lucknow, Uttar Pradesh',
        classSection: '10 - A',
        conveyance: 'Bus',
        dob: '12 Aug 2009',
        mobile: '9876543210',
        photoUrl: 'https://i.pravatar.cc/150?img=12',
      ),
      StudentIdModel(
        admissionNo: 'A1024',
        fatherName: 'Ramesh Kumar',
        motherName: 'Sita Devi',
        address: 'Kanpur, Uttar Pradesh',
        classSection: '9 - B',
        conveyance: 'Van',
        dob: '23 May 2010',
        mobile: '9123456780',
        photoUrl: 'https://i.pravatar.cc/150?img=14',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const CommonAppBar(
        title: 'Student ID Cards',
        backgroundColor: AppColors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          isExtended: true,
          highlightElevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            Get.toNamed(AppRoutes.addIdCard);
          },
          label: Text("Add Student"),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (_, index) {
          return _StudentIdCard(
            student: students[index],
            onEdit: () {},
            onDelete: () {},
          );
        },
      ),
    );
  }
}

class _StudentIdCard extends StatelessWidget {
  const _StudentIdCard({
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  final StudentIdModel student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.teal),
        gradient: LinearGradient(
          colors: [AppColors.teal.withOpacity(0.1), AppColors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                  color: AppColors.teal,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Canossa Ayodhya English School",
                      style: AppTextStyle.title.medium.white.bold,
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
                    child: Text('Edit', style: AppTextStyle.title.medium.teal),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Admission & Class
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// PHOTO
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.teal.withOpacity(0.3),
                      backgroundImage: NetworkImage(student.photoUrl),
                    ),
                    const SizedBox(width: 14),
                    AppTextStyle.body.large.black.bold.text(
                      'Admission: ${student.admissionNo}',
                    ),
                    const SizedBox(height: 4),
                    AppTextStyle.body.medium.black.bold.text(
                      'Class: ${student.classSection}',
                    ),
                  ],
                ),
                SizedBox(height: 25),
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
              color: AppColors.teal,
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
                    style: AppTextStyle.title.small.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: AppTextStyle.body.small.black.semiBold.text(label),
          ),
          SizedBox(
            width: 20,
            child: AppTextStyle.body.small.black.semiBold.text(":"),
          ),

          Expanded(child: AppTextStyle.body.small.black.semiBold.text(value)),
        ],
      ),
    );
  }

  Widget _chip(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyle.body.small.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.white),
            const SizedBox(width: 6),
            AppTextStyle.body.small.white.bold.text(label),
          ],
        ),
      ),
    );
  }
}
