import '../modules/shared/login/model/login_response.dart';

class AppRoutes {
  static getInitialRoute(LoginResponse? loginRes) {
    if (loginRes == null) {
      return login;
    } else if (loginRes.token != null) {
      return home;
    } else {
      return login;
    }
  }

  static const String splash = '/';

  static const String login = '/Login';

  static const String idCard = '/IdCard';
  static const String addIdCard = '/AddIdCard';

  static String get enterAdmissionNumber => "/EnterAdmissionNumber";
  static const String home = '/home';
  static const String idCardFilter = '/id_card_filter';
}
