class StudentIdModel {
  final String admissionNo;
  final String fatherName;
  final String motherName;
  final String address;
  final String classSection;
  final String conveyance;
  final String dob;
  final String mobile;
  final String photoUrl;
   bool isExpanded;

  StudentIdModel({
    required this.admissionNo,
    required this.fatherName,
    required this.motherName,
    required this.address,
    required this.classSection,
    required this.conveyance,
    required this.dob,
    required this.mobile,
    required this.photoUrl,
    required this.isExpanded,
  });
}
