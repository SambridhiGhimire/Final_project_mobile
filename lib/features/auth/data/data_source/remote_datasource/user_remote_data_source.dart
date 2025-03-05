import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../model/edit_profile_respons.dart';

class UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(this._dio);

  /// Signs up a user
  Future<String> signUp(String email, String password, String name) async {
    try {
      var response = await _dio.post(ApiEndpoints.signUp, data: {'email': email, 'password': password, 'name': name});
      if (response.statusCode == 400) throw Exception(response.data['error']);
      return response.data['message'];
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Logs in a user
  Future<LoginDTO> login(String email, String password) async {
    try {
      Response response = await _dio.post(ApiEndpoints.login, data: {'email': email, 'password': password});
      if (response.statusCode == 400) throw Exception(response.data['error']);
      final responseData = response.data;
      return LoginDTO.fromJson(responseData);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      Response response = await _dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
      if (response.statusCode == 200) return response.data['message'];
      throw Exception('An error occurred');
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<EditProfileResponse> updateProfile(String name, File? image) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        if (image != null)
          "profileImage": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split("/").last + DateTime.now().toString(),
            contentType: DioMediaType.parse('image/jpeg'),
          ),
      });

      Response response = await _dio.post(
        ApiEndpoints.editProfile,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      return EditProfileResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
