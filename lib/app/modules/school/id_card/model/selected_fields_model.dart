class SelectedFieldsModel {
  List<SelectedFields>? selectedFields;

  SelectedFieldsModel({this.selectedFields});

  SelectedFieldsModel.fromJson(Map<String, dynamic> json) {
    if (json['selectedFields'] != null) {
      selectedFields = <SelectedFields>[];
      json['selectedFields'].forEach((v) {
        selectedFields!.add(new SelectedFields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.selectedFields != null) {
      data['selectedFields'] =
          this.selectedFields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedFields {
  int? fieldId;
  String? fieldName;
  String? fieldType;
  bool? isRequired;
  bool? enforceType;


  SelectedFields(
      {this.fieldId,
        this.fieldName,
        this.fieldType,
        this.isRequired,
        this.enforceType});

  SelectedFields.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    isRequired = json['isRequired'];
    enforceType = json['enforceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldId'] = this.fieldId;
    data['fieldName'] = this.fieldName;
    data['fieldType'] = this.fieldType;
    data['isRequired'] = this.isRequired;
    data['enforceType'] = this.enforceType;
    return data;
  }
}
