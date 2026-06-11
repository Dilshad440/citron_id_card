import 'dart:convert';
import 'dart:io';

class OfflineCardsModel {
  final Map<String, dynamic> records;
  final File? selectedImage;
  final int? schoolId;
  final int? isSynced;
  final int? id;

  OfflineCardsModel({
    this.records = const {},
    this.selectedImage,
    this.isSynced = 0,
    this.schoolId,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "records": jsonEncode(records),
      "isSynced": isSynced,
      "imagePath": selectedImage?.path,
      "schoolId": schoolId,
    };
  }

  factory OfflineCardsModel.fromJson(Map<String, dynamic> json) {
    return OfflineCardsModel(
      id: json['id'],
      records: Map<String, dynamic>.from(jsonDecode(json["records"] ?? "{}")),
      isSynced: json["isSynced"] ?? 0,
      schoolId: json["schoolId"],
      selectedImage: json["imagePath"] != null ? File(json["imagePath"]) : null,
    );
  }
}
