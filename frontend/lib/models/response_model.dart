class ResponseModel {
  final String code;
  final String message;
  final dynamic data;

  // JSON 데이터를 받아 ResponseModel 객체로 변환하는 생성자
  ResponseModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        data = json['data'];
}
