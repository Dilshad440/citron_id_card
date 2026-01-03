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
  String? user;

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
    this.user,
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
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schoolId'] = this.schoolId;
    data['schoolName'] = this.schoolName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['contactNo'] = this.contactNo;
    data['email'] = this.email;
    data['website'] = this.website;
    data['logo'] = this.logo;
    data['schoolCode'] = this.schoolCode;
    data['isActive'] = this.isActive;
    data['updatedOn'] = this.updatedOn;
    data['customerId'] = this.customerId;
    data['userId'] = this.userId;
    data['updatedBy'] = this.updatedBy;
    data['password'] = this.password;
    data['canAdd'] = this.canAdd;
    data['canDelete'] = this.canDelete;
    data['canEdit'] = this.canEdit;
    data['selectedFields'] = this.selectedFields;
    data['customer'] = this.customer;
    data['user'] = this.user;
    return data;
  }
}
