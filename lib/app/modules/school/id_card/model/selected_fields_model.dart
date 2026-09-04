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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (selectedFields != null) {
      data['selectedFields'] = selectedFields!.map((v) => v.toJson()).toList();
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
  int? sequenceNo;

  SelectedFields({
    this.fieldId,
    this.fieldName,
    this.fieldType,
    this.isRequired,
    this.enforceType,
    this.sequenceNo,
  });

  SelectedFields.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    isRequired = json['isRequired'];
    enforceType = json['enforceType'];
    sequenceNo = json['sequenceNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fieldId'] = fieldId;
    data['fieldName'] = fieldName;
    data['fieldType'] = fieldType;
    data['isRequired'] = isRequired;
    data['enforceType'] = enforceType;
    data['sequenceNo'] = sequenceNo;
    return data;
  }
}
