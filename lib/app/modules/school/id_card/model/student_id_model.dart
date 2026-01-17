import 'dart:io';

class StudentIdModel {
  int? id;
  String? photo;
  int? photoSize;
  String? updatedOn;
  int? updatedBy;
  bool? isExpanded;
  File? selectedImg;
  StudentData? data;

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

  StudentIdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    photoSize = json['photo_size'];
    updatedOn = json['updated_on'];
    updatedBy = json['updatedBy'];
    isExpanded = false;

    data = json['data'] != null ? new StudentData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['photo_size'] = this.photoSize;
    data['updated_on'] = this.updatedOn;
    data['updatedBy'] = this.updatedBy;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StudentData {
  String? dOB;
  String? cls;
  String? house;
  String? pENNo;
  String? address;
  String? admNo;
  String? empID;
  String? rollNo;
  String? section;
  String? session;
  String? emailID;
  String? aadharNo;
  String? stopName;
  String? contactNo;
  String? convName;
  String? department;
  String? bloodGroup;
  String? designation;
  String? driverName;
  String? fatherName;
  String? motherName;
  String? emergencyNo;
  String? husbandName;
  String? studentName;
  String? driverMobile;
  String? optedConveyance;

  StudentData({
    this.dOB,
    this.cls,
    this.house,
    this.pENNo,
    this.address,
    this.admNo,
    this.empID,
    this.rollNo,
    this.section,
    this.session,
    this.emailID,
    this.aadharNo,
    this.stopName,
    this.contactNo,
    this.convName,
    this.department,
    this.bloodGroup,
    this.designation,
    this.driverName,
    this.fatherName,
    this.motherName,
    this.emergencyNo,
    this.husbandName,
    this.studentName,
    this.driverMobile,
    this.optedConveyance,
  });

  StudentData.fromJson(Map<String, dynamic> json) {
    dOB = json['DOB'];
    cls = json['Class'];
    house = json['House'];
    pENNo = json['PEN No'];
    address = json['Address'];
    admNo = json['Adm. No'];
    empID = json['Emp. ID'];
    rollNo = json['Roll No'];
    section = json['Section'];
    session = json['Session'];
    emailID = json['Email ID'];
    aadharNo = json['Aadhar No'];
    stopName = json['Stop Name'];
    contactNo = json['Contact No'];
    convName = json['Conv. Name'];
    department = json['Department'];
    bloodGroup = json['Blood Group'];
    designation = json['Designation'];
    driverName = json['Driver Name'];
    fatherName = json['Father Name'];
    motherName = json['Mother Name'];
    emergencyNo = json['Emergency No'];
    husbandName = json['Husband Name'];
    studentName = json['Student Name'];
    driverMobile = json['Driver Mobile'];
    optedConveyance = json['Opted Conveyance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DOB'] = this.dOB;
    data['Class'] = this.cls;
    data['House'] = this.house;
    data['PEN No'] = this.pENNo;
    data['Address'] = this.address;
    data['Adm. No'] = this.admNo;
    data['Emp. ID'] = this.empID;
    data['Roll No'] = this.rollNo;
    data['Section'] = this.section;
    data['Session'] = this.session;
    data['Email ID'] = this.emailID;
    data['Aadhar No'] = this.aadharNo;
    data['Stop Name'] = this.stopName;
    data['Contact No'] = this.contactNo;
    data['Conv. Name'] = this.convName;
    data['Department'] = this.department;
    data['Blood Group'] = this.bloodGroup;
    data['Designation'] = this.designation;
    data['Driver Name'] = this.driverName;
    data['Father Name'] = this.fatherName;
    data['Mother Name'] = this.motherName;
    data['Emergency No'] = this.emergencyNo;
    data['Husband Name'] = this.husbandName;
    data['Student Name'] = this.studentName;
    data['Driver Mobile'] = this.driverMobile;
    data['Opted Conveyance'] = this.optedConveyance;
    return data;
  }
}
