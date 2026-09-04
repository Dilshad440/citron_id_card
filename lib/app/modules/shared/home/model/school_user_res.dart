import 'package:flutter/cupertino.dart';

class SchoolUserRes {
  int? schoolId;
  String? schoolName;
  String? address1;
  String? address2;
  String? address3;
  String? contactNo;
  String? email;
  String? website;
  String? logo;
  String? schoolCode;
  bool? isActive;
  String? updatedOn;
  int? customerId;
  int? userId;
  String? updatedBy;
  String? password;
  bool? canAdd;
  bool? canDelete;
  bool? canEdit;
  String? selectedFields;
  String? customer;
  bool? allowOfflineMode;
  String? user;
  String? textCase;

  SchoolUserRes({
    this.schoolId,
    this.schoolName,
    this.address1,
    this.address2,
    this.address3,
    this.contactNo,
    this.email,
    this.website,
    this.logo,
    this.schoolCode,
    this.isActive,
    this.updatedOn,
    this.customerId,
    this.userId,
    this.updatedBy,
    this.password,
    this.canAdd,
    this.canDelete,
    this.canEdit,
    this.selectedFields,
    this.customer,
    this.allowOfflineMode,
    this.user,
    this.textCase,
  });

  SchoolUserRes.fromJson(Map<String, dynamic> json) {
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    contactNo = json['contactNo'];
    email = json['email'];
    website = json['website'];
    logo = json['logo'];
    schoolCode = json['schoolCode'];
    isActive = json['isActive'];
    updatedOn = json['updatedOn'];
    customerId = json['customerId'];
    userId = json['userId'];
    updatedBy = json['updatedBy'];
    password = json['password'];
    canAdd = json['canAdd'];
    canDelete = json['canDelete'];
    canEdit = json['canEdit'];
    selectedFields = json['selectedFields'];
    customer = json['customer'];
    allowOfflineMode = json['allowOfflineMode'];
    user = json['user'];
    textCase = json['textCase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['contactNo'] = contactNo;
    data['email'] = email;
    data['website'] = website;
    data['logo'] = logo;
    data['schoolCode'] = schoolCode;
    data['isActive'] = isActive;
    data['updatedOn'] = updatedOn;
    data['customerId'] = customerId;
    data['userId'] = userId;
    data['updatedBy'] = updatedBy;
    data['password'] = password;
    data['canAdd'] = canAdd;
    data['canDelete'] = canDelete;
    data['canEdit'] = canEdit;
    data['selectedFields'] = selectedFields;
    data['customer'] = customer;
    data['user'] = user;
    data['allowOfflineMode'] = allowOfflineMode;
    data['textCase'] = textCase;

    return data;
  }

  TextCapitalization get textCapitalization {
    if (textCase?.toLowerCase() == "propercase") {
      return TextCapitalization.words;
    } else if (textCase?.toLowerCase() == "uppercase") {
      return TextCapitalization.characters;
    } else {
      return TextCapitalization.none;
    }
  }
}
