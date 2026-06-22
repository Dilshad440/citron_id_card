class ApiConstants {
  /// Production
  // static const String baseUrl = 'https://testidapp.citronsoftwares.com';

  /// Testing
  static const String baseUrl = 'https://iddev.citronsoftwares.com';
  static const String login = '/api/auth/login';
  static const String getSchoolUser = '/api/idrecords/getschoolforuser';
  static const String schoolIdList = '/api/IDRecords/filter';
  static const String uploadPhoto = '/api/photoupload/upload-base64';
  static const String uploadBulkPhoto = '/api/photoupload/bulk-upload-base64';
  static const String sectionList = '/api/IDRecords/sections';
  static const String classList = '/api/IDRecords/classnames';
  static const String addIdCard = '/api/idrecords';
  static const String addBulkIdCard = '/api/idrecords/bulk-create';
  static const String editIdCard = '/api/IDRecords/';
  static const String sessions = '/api/Sessions';

  static String listValuesByFieldName({
    required int schoolId,
    required String fieldName,
  }) =>
      '/api/listvalues/by-school-field?schoolId=$schoolId&fieldName=$fieldName';
}
