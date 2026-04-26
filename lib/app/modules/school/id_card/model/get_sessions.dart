class GetSessions {
  List<Sessions>? sessions;
  String? defaultSession;

  GetSessions({this.sessions, this.defaultSession});

  GetSessions.fromJson(Map<String, dynamic> json) {
    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(new Sessions.fromJson(v));
      });
    }
    defaultSession = json['defaultSession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sessions != null) {
      data['sessions'] = this.sessions!.map((v) => v.toJson()).toList();
    }
    data['defaultSession'] = this.defaultSession;
    return data;
  }
}

class Sessions {
  int? id;
  String? session;
  bool? isDefault;

  Sessions({this.id, this.session, this.isDefault});

  Sessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    session = json['session'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['session'] = this.session;
    data['isDefault'] = this.isDefault;
    return data;
  }
}
