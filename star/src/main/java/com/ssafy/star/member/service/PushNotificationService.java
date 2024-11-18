package com.ssafy.star.member.service;

import com.google.firebase.messaging.AndroidConfig;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.ssafy.star.exception.CustomErrorCode;
import com.ssafy.star.exception.CustomException;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
public class PushNotificationService {

    private final FirebaseMessaging firebaseMessaging;

    public PushNotificationService(FirebaseMessaging firebaseMessaging) {
        this.firebaseMessaging = firebaseMessaging;
    }

    @Async
    public void sendPushNotification(String token, String id, String title, String content) {

//        Notification notification = Notification.builder()
//                .setTitle(title)
//                .setBody(content)
//                .build();

        Message message = Message.builder()
                .setToken(token)
                .putData("notificationId", id)
                .putData("title", title)
                .putData("content", content)
//                .setNotification(notification)
                .setAndroidConfig(AndroidConfig.builder()
                        .setTtl(Duration.ofMinutes(5).toMillis())
                        .build())
                .build();

        try {
            firebaseMessaging.sendAsync(message);
        } catch (Exception e) {
            // 기타 예외 처리
            throw new CustomException(CustomErrorCode.PUSH_NOTIFICATION_FAILED);
        }
    }

    @Async
    public void sendPushNotification(String token, String title, String content, String id, String hint, String image) {

        if (hint == null || hint.trim().equals("")) {
            hint = "힌트가 없어요ㅠ0ㅠ";
        }

        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(content + "\n힌트 : " + hint)
                .setImage(image)
                .build();

        Message message = Message.builder()
                .setToken(token)
                .putData("notificationId", id)
//                .putData("title", title)
//                .putData("content", content)
//                .putData("image", image)
                .setNotification(notification)
                .setAndroidConfig(AndroidConfig.builder()
                        .setTtl(Duration.ofMinutes(5).toMillis())
                        .build())
                .build();

        try {
            firebaseMessaging.sendAsync(message);
        } catch (Exception e) {
            // 기타 예외 처리
            throw new CustomException(CustomErrorCode.PUSH_NOTIFICATION_FAILED);
        }
    }

    @Async
    public void sendPushNotificationCommonMessage(String token, String notificationId, String messageId, String title, String content) {

//        Notification notification = Notification.builder()
//                .setTitle(title)
//                .setBody(content)
//                .build();

        Message message = Message.builder()
                .setToken(token)
                .putData("title", title)
                .putData("content", content)
                .putData("notificationId", notificationId)
                .putData("messageId", messageId)
//                .setNotification(notification)
                .setAndroidConfig(AndroidConfig.builder()
                        .setTtl(Duration.ofMinutes(5).toMillis())
                        .build())
                .build();

        try {
            firebaseMessaging.sendAsync(message);
        } catch (Exception e) {
            // 기타 예외 처리
            throw new CustomException(CustomErrorCode.PUSH_NOTIFICATION_FAILED);
        }
    }

}
