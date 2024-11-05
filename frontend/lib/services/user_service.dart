import 'package:dio/dio.dart';
import 'package:star23sharp/models/response_model.dart';
import 'package:star23sharp/services/dio_service.dart';

class UserService {

  // 아이디 및 닉네임 중복 확인
  Future<bool> checkDuplicateId(int checkType, String value) async {
    // checkType -> 0: ID, 1: 닉네임
    try {
      final response = await DioService.dio.post(
        '/member/duplicate',
        data: {
          'checkType': checkType,
          'value': value,
        },
      );

      var result = ResponseModel.fromJson(response.data);
      if(result.code == '200'){
        return false;
      } else {
        return true;
      }

    } on DioException catch (e) {
      print('Failed to create post: $e');
      throw Exception('Failed to create post');
    }
  }

  // 회원가입
  Future<bool> signup(String memberId, String password, String nickname) async {
    // checkType -> 0: ID, 1: 닉네임
    try {
      final response = await DioService.dio.post(
        '/member/join',
        data: {
          'memberId': memberId,
          'password': password,
          'nickname': nickname,
        },
      );

      var result = ResponseModel.fromJson(response.data);
      if(result.code == '200'){
        return true;
      } else {
        return false;
      }

    } on DioException catch (e) {
      print('Failed to create post: $e');
      throw Exception('Failed to create post');
    }
  }

  // 로그인
  Future<bool> login(String memberId, String password) async {
    // checkType -> 0: ID, 1: 닉네임
    try {
      final response = await DioService.dio.post(
        '/login',
        data: {
          'memberId': memberId,
          'password': password,
        },
      );

      var result = ResponseModel.fromJson(response.data);
      if(result.code == '200'){
        print(response.headers);
        // 특정 헤더 값을 가져오는 방법
        // String? authorization = response.headers.value('Authorization'); // 예시: Authorization 헤더
        // String? anotherHeader = response.headers.value('Another-Header');
        return true;
      } else {
        return false;
      }

    } on DioException catch (e) {
      print('Failed to create post: $e');
      throw Exception('Failed to create post');
    }
  }

}
