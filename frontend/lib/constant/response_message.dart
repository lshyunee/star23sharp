class ResponseMessage {
  static const String success = "성공";
  static const String noContent = "데이터가 없습니다.";
  static const String badRequest = "입력값이 필수 조건에 만족하지 않습니다.";
  static const String unsupportedMethod = "지원하지 않는 메서드입니다.";

  static const String groupMemberNotFound = "그룹 멤버가 존재하지 않거나 비활성 상태입니다.";
  static const String groupNotFound = "그룹이 존재하지 않습니다.";
  static const String groupNoPermission = "그룹에 대한 접근 권한이 없습니다.";

  static const String letterNotFound = "쪽지가 존재하지 않습니다.";
  static const String letterNoPermission = "쪽지에 접근할 권한이 없습니다.";
  static const String letterAlreadyReported = "이미 신고된 쪽지입니다.";
  static const String unsupportedFileType = "지원하지 않는 파일 형식입니다.";
  static const String imageFileSaveError = "이미지 파일 저장 중 오류가 발생했습니다.";
  static const String recipientNotFound = "수신자가 존재하지 않습니다.";
  static const String invalidLatLong = "위도와 경도 값이 유효하지 않습니다.";
  static const String invalidImageSize = "업로드 가능한 파일 크기를 초과했습니다.";
  static const String ambiguousReceivers = "수신 대상이 불분명합니다.";
  static const String unhandledException = "기타 예외 미처리 에러입니다.";
  static const String gpuProxyConnectionError = "GPU 프록시 서버 연결 오류";
  static const String treasureNoteNotFound = "존재하지 않는 보물 쪽지입니다.";
  static const String noPermissionTreasureNote = "열람 권한이 없는 보물 쪽지입니다.";
  static const String invalidPixelationTarget = "픽셀화 대상이 잘못되었습니다.";
  static const String gpuProxyServerError = "GPU 프록시 서버 오류가 발생했습니다.";
  static const String invalidEmbeddingCount = "임베딩 개수가 유효하지 않습니다.";
  static const String reasonNotFound = "해당 신고 사유를 찾을 수 없습니다.";
  static const String invalidDateFormat = "날짜 형식이 올바르지 않습니다.";
  static const String messageTitleTooLong = "쪽지 제목이 너무 깁니다.";
  static const String messageContentTooLong = "쪽지 내용이 너무 깁니다.";
  static const String treasureHintTooLong = "보물 쪽지 힌트가 너무 깁니다.";
  static const String selfAsRecipient = "쪽지 수신자 중에 자기 자신이 포함되어 있습니다.";
  static const String searchRangeTooWide = "검색 범위가 너무 넓습니다.";
  static const String invalidImageType =
      "잘못된 이미지 형식입니다. png, jpg, jpeg 파일만 허용됩니다.";
  static const String harmfulImage = "이미지가 유해한 이미지로 판단됩니다.";

  static const String expiredToken = "만료된 토큰입니다.";
  static const String duplicateUserId = "이미 사용된 회원 ID입니다.";
  static const String nicknameAlreadyExists = "이미 존재하는 닉네임입니다.";
  static const String mismatchedMemberInfo = "회원 정보가 일치하지 않습니다.";
  static const String incorrectPassword = "현재 비밀번호가 일치하지 않습니다.";
  static const String memberNotFound = "회원이 존재하지 않습니다.";
  static const String emptyRefreshToken = "Refresh Token이 비어있습니다.";
  static const String emptyAccessToken = "Access Token이 비어있습니다.";
  static const String invalidToken = "유효하지 않은 토큰입니다.";
  static const String invalidDeviceToken = "잘못된 디바이스 토큰입니다.";
  static const String deviceTokenNotFound = "디바이스 토큰을 찾을 수 없습니다.";
  static const String nicbookNotFound = "존재하지 않는 닉북입니다.";
  static const String nickbookNoPermission = "해당 닉북에 접근할 권한이 없습니다.";
  static const String nickbookAlreadyExists = "이미 닉북에 등록된 닉네임입니다.";

  static const String pushNotificationFailed = "푸시 알림 전송에 실패했습니다.";
  static const String invalidPushDeviceToken = "유효하지 않은 디바이스 토큰입니다.";
  static const String expiredPushDeviceToken = "만료된 디바이스 토큰입니다.";
  static const String pushAuthError = "푸시 알림 인증 오류가 발생했습니다.";
  static const String pushMessageTooLarge = "푸시 알림 메시지 크기가 초과되었습니다.";
  static const String notificationNotFound = "알림이 존재하지 않습니다.";
  static const String noPermissionNotification = "알림에 접근할 권한이 없습니다.";
}
