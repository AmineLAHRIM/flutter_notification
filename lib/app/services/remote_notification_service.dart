import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/app/services/local_notification_service.dart';
import 'package:flutter_notification/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

@lazySingleton
class RemoteNotificationService {
  final Dio dio;
  static String? _testToken;

  RemoteNotificationService(this.dio);

  static Future<void> initializeRemoteNotifications({required bool debug}) async {
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: mySilentDataHandle,
      onFcmTokenHandle: myFcmTokenHandle,
      onNativeTokenHandle: myNativeTokenHandle,
      licenseKeys: [],
      debug: debug,
    );
  }

  // Remote Notification Event Listener

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    Fluttertoast.showToast(
        msg: 'Silent data received', backgroundColor: Colors.blueAccent, textColor: Colors.white, fontSize: 16);

    print('"SilentData": ${silentData.data}');

    if (silentData.data!['IsLiveScore'] == "true") {
      LocalNotificationService.createLiveScoreNotification(
        id: 1,
        title: silentData.data!['title']!,
        body: silentData.data!['body']!,
        largeIcon: silentData.data!['largeIcon'],
      );
    }

    if (silentData.createdLifeCycle == NotificationLifeCycle.Foreground) {
      print("FOREGROUND");
    } else {
      print("BACKGROUND");
    }
  }

  /// Use this method to detect when a new fcm token is received
  static Future<void> myFcmTokenHandle(String token) async {
    _testToken=token;
    Fluttertoast.showToast(
        msg: 'Fcm token received', backgroundColor: Colors.blueAccent, textColor: Colors.white, fontSize: 16);

    debugPrint('Firebase Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  static Future<void> myNativeTokenHandle(String token) async {
    Fluttertoast.showToast(
        msg: 'Native token received', backgroundColor: Colors.blueAccent, textColor: Colors.white, fontSize: 16);

    debugPrint('Native Token:"$token"');
  }

  Future<void> sendPushMessage() async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": Constant.GOOGLE_APPLICATION_CREDENTIALS['private_key_id'],
      "private_key": Constant.GOOGLE_APPLICATION_CREDENTIALS['private_key'],
      "client_email": Constant.GOOGLE_APPLICATION_CREDENTIALS['client_email'],
      "client_id": Constant.GOOGLE_APPLICATION_CREDENTIALS['client_id'],
      "type": Constant.GOOGLE_APPLICATION_CREDENTIALS['type'],
    });

    var client = http.Client();
    AccessCredentials credentials = await obtainAccessCredentialsViaServiceAccount(
        accountCredentials, Constant.GOOGLE_APPLICATION_FCM_SCOPES, client);
    client.close();
    final accessToken = credentials.accessToken.data;
    Logger().d('accessToken=$accessToken');

    try {
      final projectId = Constant.GOOGLE_APPLICATION_CREDENTIALS['project_id'];

      final response = await dio.post(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
        data: {
          "message": {
            "token": "eoJGSCGTQMyBHK0sEdMUYb:APA91bGFLKmDqTZFugk5-Sp0ivsVgHGHOrMvWdWDswNb8ZNTq6wMpYx0BXIhsFdxMMjM6bzhKgcGIs2145NR9HaHMgNkc0MR6ioZVAOfag4OOnkDRzuARBShntwAGTHYy3sNfqEioqkm",
            "notification": {"body": "This is an FCM notification message from App!", "title": "FCM Message"},
          },
        },
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
        ),
      );
      //final responseData = response.data;
      Logger().i(response.requestOptions.data);
      if (response.statusCode == 200) {
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      final response = e.response;
      if (response?.data == null || response!.statusCode! >= 500) {
        return;
      }
    }
  }

   Future<void> subscribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().subscribeToTopic(topic);
    print("Subcribe to $topic");
  }

   Future<void> unSubcribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().unsubscribeToTopic(topic);
    print("UnSubcribe to $topic");
  }
}
