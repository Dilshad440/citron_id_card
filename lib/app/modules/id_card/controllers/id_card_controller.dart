import 'package:get/get.dart';

import '../model/student_id_model.dart';

class IdCardController extends GetxController {
  List<StudentIdModel> idCards = [];

  @override
  void onInit() {
    getIdCards();
    super.onInit();
  }

  void getIdCards() {
    idCards = <StudentIdModel>[
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
        isExpanded: false,
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
        isExpanded: false,
      ),
    ];
    update(["idCard"]);
  }

  void expandCard(int index, bool expand) {
    idCards[index].isExpanded = expand;
    update(['idCard']);
  }
}
