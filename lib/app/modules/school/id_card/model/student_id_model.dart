class SchoolIDRes {
  List<Records>? records;

  SchoolIDRes({this.records});

  SchoolIDRes.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  int? id;
  String? photo;
  int? photoSize;
  String? updatedOn;
  int? updatedBy;
  Data? data;
  List<String>? fields;
  bool? isExpanded;

  Records({
    this.id,
    this.photo,
    this.photoSize,
    this.updatedOn,
    this.updatedBy,
    this.data,
    this.fields,
    this.isExpanded = false,
  });

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    photoSize = json['photo_size'];
    updatedOn = json['updated_on'];
    updatedBy = json['updatedBy'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    fields = json['fields'].cast<String>();
    isExpanded = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photo'] = photo;
    data['photo_size'] = photoSize;
    data['updated_on'] = updatedOn;
    data['updatedBy'] = updatedBy;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['fields'] = fields;
    return data;
  }
}

class Data {
  String? clas;
  String? admNo;
  String? section;
  String? studentName;

  Data({this.clas, this.admNo, this.section, this.studentName});

  Data.fromJson(Map<String, dynamic> json) {
    clas = json['Class'];
    admNo = json['Adm. No'];
    section = json['Section'];
    studentName = json['Student Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Class'] = clas;
    data['Adm. No'] = admNo;
    data['Section'] = section;
    data['Student Name'] = studentName;
    return data;
  }
}
