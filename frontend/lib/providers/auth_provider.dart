import 'package:flutter/material.dart';
import 'package:star23sharp/main.dart';
import 'package:star23sharp/services/index.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  bool get isLoggedIn => _accessToken != null && _refreshToken != null;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  
  Future<void> setToken(String accessToken, String refreshToken) async {
    // 로그인, 액세스 토큰 재발급 시 -> refresh 토큰도 갱신
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await storage.write(key: 'access', value: accessToken);
    await storage.write(key: 'refresh', value: refreshToken);
    logger.d("토큰 세팅 됨! $accessToken $refreshToken");
    DioService.updateAuthorizationHeader(accessToken);
    notifyListeners();
  }

  Future<void> clearTokens() async{
    logger.d("토큰 clear!");
    _accessToken = null;
    _refreshToken = null;
    await storage.delete(key: 'access');
    await storage.delete(key: 'refresh');
    notifyListeners();
  }

  Future<String?> refreshTokens() async {
    try {
      logger.d("토큰 갱신 중 - 현재 리프레시 토큰: $refreshToken");
      if(refreshToken != null){
        Map<String, String>? response = await UserService.refreshToken(refreshToken!);
        logger.d("토큰 갱신 response: $response");
        if(response != null){
          await setToken(response['access']!, response['refresh']!);
          return response['access']!;
        }else{
          clearTokens();
          return null;
        }
      }else{
        //TODO - 로그아웃 처리 -> 로그인화면으로 이동
        clearTokens();
        return null;
      }
    } catch (e) {
      logger.d('토큰 갱신 실패: $e');
      return null;
    }
  }
}
