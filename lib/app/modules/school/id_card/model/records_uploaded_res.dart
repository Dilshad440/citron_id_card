class RecordsUploadRes {
  List<CreatedIds>? createdIds;
  int? totalProcessed;
  int? successCount;

  RecordsUploadRes({this.createdIds, this.totalProcessed, this.successCount});

  RecordsUploadRes.fromJson(Map<String, dynamic> json) {
    if (json['createdIds'] != null) {
      createdIds = <CreatedIds>[];
      json['createdIds'].forEach((v) {
        createdIds!.add(new CreatedIds.fromJson(v));
      });
    }

    totalProcessed = json['totalProcessed'];
    successCount = json['successCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.createdIds != null) {
      data['createdIds'] = this.createdIds!.map((v) => v.toJson()).toList();
    }

    data['totalProcessed'] = this.totalProcessed;
    data['successCount'] = this.successCount;
    return data;
  }
}

class CreatedIds {
  int? offlineId;
  int? id;

  CreatedIds({this.offlineId, this.id});

  CreatedIds.fromJson(Map<String, dynamic> json) {
    offlineId = json['offlineId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offlineId'] = this.offlineId;
    data['id'] = this.id;
    return data;
  }
}
