import 'package:citron_id_card/app/config/network/api_constants.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/student_id_model.dart';
import 'package:dio/dio.dart';
import '../config/network/dio_client.dart';
import '../modules/shared/home/model/school_user_res.dart';
import '../modules/shared/login/model/login_response.dart';

class ApiService {
  final DioClient client;

  ApiService({required this.client});

  /// Example API call
  Future<Response> fetchUsers() {
    return client.dio.get('https://jsonplaceholder.typicode.com/users');
  }

  Future<LoginResponse> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await client.dio.post(
        ApiConstants.login,
        data: {"userName": userName, "password": password},
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SchoolUserRes>> getSchoolUsers() async {
    try {
      List<SchoolUserRes> schoolUser = [];
      final response = await client.dio.get(ApiConstants.getSchoolUser);

      final responseList = response.data as List<dynamic>;
      for (var element in responseList) {
        schoolUser.add(SchoolUserRes.fromJson(element));
      }
      return schoolUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<SchoolIDRes> getSchoolId(Map<String, dynamic> data) async {
    try {
      final response = await client.dio.get(
        ApiConstants.schoolIdList,
        queryParameters: data, // ✅ sends parameters as ?key=value
      );
      return SchoolIDRes.fromJson(response.data);
    } catch (e) {
      rethrow; // ✅ bubbles up the error
    }
  }

  Future<Response> uploadPhoto({
    required String base64,
    required int stdId,
  }) async {
    try {
      final response = await client.dio.post(
        ApiConstants.uploadPhoto,
        data: {"IdRecordId": stdId, "Base64Photo": base64},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
