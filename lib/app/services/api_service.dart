import 'dart:convert';

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

  Future<List<String>> getSelectedFields(int schoolId) async {
    try {
      final response = await client.dio.get('/api/idfields/$schoolId/selected');

      final List<dynamic> data = response.data['selectedFieldNames'];

      return data.map((e) => e.toString()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> addIdCard(Map<String, dynamic> request) async {
    final response = await client.dio.post(
      ApiConstants.addIdCard,
      data: request,
    );
    return response;
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

  Future<List<StudentIdModel>> getSchoolId(Map<String, dynamic> data) async {
    try {
      print("STRICT PAYLOAD: ${jsonEncode(data)}"); // Check this log!

      final response = await client.dio.post(
        ApiConstants.schoolIdList,
        data: data,
      );

      final List<dynamic> schoolData = response.data;
      return schoolData.map((v) => StudentIdModel.fromJson(v)).toList();
    } on DioException catch (e) {
      rethrow;
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

  Future<List<dynamic>> getClassAndSection(String session, int schoolId) async {
    try {
      // 1. Fetch Sections
      final sectionRes = await client.dio.get(
        ApiConstants.sectionList,
        queryParameters: {"schoolId": schoolId, "session": session},
      );

      // Use .map() for cleaner data extraction
      final List<dynamic> sectionData = sectionRes.data;
      List<String> sectionList = sectionData
          .map((v) => v['section_name'].toString())
          .toList();

      // 2. Fetch Classes (Uncommented and fixed)
      final classRes = await client.dio.get(
        ApiConstants.classList,
        queryParameters: {"schoolId": schoolId, "session": session},
      );

      final List<dynamic> classData = classRes.data;
      List<String> classList = classData
          .map((v) => v['class_name'].toString())
          .toList();

      // 3. Return as a Map or a nested List so you can identify them
      return [classList, sectionList];
    } catch (e) {
      // Log the error for debugging
      print("Error in getClassAndSection: $e");
      rethrow;
    }
  }
}
