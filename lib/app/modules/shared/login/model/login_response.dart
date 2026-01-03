class LoginResponse {
  String? token;
  User? user;

  LoginResponse({this.token, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? userName;
  int? userType;
  String? displayName;

  User({this.id, this.userName, this.userType, this.displayName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    userType = json['userType'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['userType'] = userType;
    data['displayName'] = displayName;
    return data;
  }
}
