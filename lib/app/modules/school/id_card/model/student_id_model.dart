import 'dart:io';

class StudentIdModel {
  int? id;
  String? photo;
  int? photoSize;
  DateTime? updatedOn;
  int? updatedBy;
  StudentData? data;
  bool isExpanded;
  File? selectedImg;

  StudentIdModel({
    this.id,
    this.photo,
    this.photoSize,
    this.updatedOn,
    this.updatedBy,
    this.data,
    this.isExpanded = false,
    this.selectedImg,
  });

  factory StudentIdModel.fromJson(Map<String, dynamic> json) => StudentIdModel(
    id: json["id"],
    photo: json["photo"],
    photoSize: json["photo_size"],
    updatedOn: json["updated_on"] == null
        ? null
        : DateTime.parse(json["updated_on"]),
    updatedBy: json["updatedBy"],
    data: json["data"] == null ? null : StudentData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "photo_size": photoSize,
    "updated_on": updatedOn?.toIso8601String(),
    "updatedBy": updatedBy,
    "data": data?.toJson(),
  };
}

class StudentData {
  String? studentClass; // Renamed from 'Class' to avoid keyword conflict
  String? admNo;
  String? section;
  String? studentName;

  StudentData({this.studentClass, this.admNo, this.section, this.studentName});

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
    studentClass: json["Class"],
    admNo: json["Adm. No"],
    section: json["Section"],
    studentName: json["Student Name"],
  );

  Map<String, dynamic> toJson() => {
    "Class": studentClass,
    "Adm. No": admNo,
    "Section": section,
    "Student Name": studentName,
  };
}
