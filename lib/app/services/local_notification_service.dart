import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

int createUniqueID(int maxValue) {
  Random random = Random();
  return random.nextInt(maxValue);
}

@lazySingleton
class LocalNotificationService {
  static Future<void> initializeLocalNotifications({required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      // 'resource://drawable/res_naruto.png',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          // defaultPrivacy: NotificationPrivacy.Secret,
          enableVibration: true,
          defaultColor: Colors.redAccent,
          channelShowBadge: true,
          enableLights: true,
          // icon: 'resource://drawable/res_naruto',
          // playSound: true,
          // soundSource: 'resource://raw/naruto_jutsu',
        ),
        NotificationChannel(
          channelGroupKey: "chat_tests",
          channelKey: "chats",
          channelName: "Group chats",
          channelDescription: 'This is a simple example channel of a chat group',
          channelShowBadge: true,
          importance: NotificationImportance.Max,
        )
      ],
      debug: debug,
    );
  }

  static scheduleNotification() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple Button',
          bigPicture:
              "https://images.unsplash.com/photo-1519114056088-b877fe073a5e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1033&q=80",
          notificationLayout: NotificationLayout.BigPicture,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
        schedule: NotificationCalendar(
          // weekday: 1,
          // hour: 19,
          // minute: 30,
          second: 5,
          repeats: false,
        ));
  }

// ACTION BUTTON
  static Future<void> showNotificationWithActionButtons(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Anonymous says:',
        body: 'Hi there!',
      ),
      actionButtons: [
        NotificationActionButton(
          key: "SUBCRIBE",
          label: "Subcribe",
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: 'Dismiss',
          actionType: ActionType.Default,
          autoDismissible: true,
          // enabled: false,
          // color: Colors.greenAccent,
          isDangerousOption: true,
        ),
      ],
    );
  }

  // CHAT NOTIFICATION

  static Future<void> createMessagingNotification({
    required String channelKey,
    required String groupKey,
    required String chatName,
    required String username,
    required String message,
    String? largeIcon,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueID(AwesomeNotifications.maxID),
        groupKey: groupKey,
        channelKey: channelKey,
        summary: chatName,
        title: username,
        body: message,
        largeIcon: largeIcon,
        notificationLayout: NotificationLayout.MessagingGroup,
        category: NotificationCategory.Message,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'REPLY',
          label: 'Reply',
          requireInputText: true,
          autoDismissible: false,
        ),
        NotificationActionButton(
          key: 'READ',
          label: 'Mark as Read',
          autoDismissible: true,
        )
      ],
    );
  }

// PROGRESS BAR NOTIFICATION

  static Future<void> showIndeterminateProgressNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Downloading fake file...',
        body: 'filename.txt',
        category: NotificationCategory.Progress,
        payload: {
          'file': 'filename.txt',
        },
        notificationLayout: NotificationLayout.ProgressBar,
        progress: null,
        locked: true,
      ),
    );

    // FOR DEMO
    await Future.delayed(const Duration(seconds: 5));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Download finished',
        body: 'filename.txt',
        category: NotificationCategory.Progress,
        locked: false,
      ),
    );
  }

  static int currentStep = 0;

  /// Create a Demo progress bar notification
  static Future<void> showProgressNotification(int id) async {
    int maxStep = 10;
    for (var simulatedStep = 1; simulatedStep <= maxStep + 1; simulatedStep++) {
      currentStep = simulatedStep;
      await Future.delayed(const Duration(seconds: 1));

      _updateCurrentProgressBar(id: id, simulatedStep: currentStep, maxStep: maxStep);
    }
  }

  /// The trick to create progress notification is
  /// to create a new notification with update progress and
  /// send the notification to the same id
  static void _updateCurrentProgressBar({
    required int id,
    required int simulatedStep,
    required int maxStep,
  }) {
    if (simulatedStep > maxStep) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Download finished',
          body: 'filename.txt',
          category: NotificationCategory.Progress,
          payload: {
            'file': 'filename.txt',
          },
          locked: false,
        ),
      );
    } else {
      int progress = min((simulatedStep / maxStep * 100).round(), 100);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Downloading fake file in progress ($progress%)',
          body: 'filename.txt',
          category: NotificationCategory.Progress,
          payload: {
            'file': 'filename.txt',
          },
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress,
          locked: true,
        ),
      );
    }
  }

  /// Create  notificatoin with Emoji
  static Future<void> showEmojiNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        category: NotificationCategory.Social,
        title: 'Emojis are awesome too! 😂🌟🌟 ${Emojis.smile_face_with_tongue}${Emojis.smile_smiling_face}',
        body:
            'Simple body with a bunch of Emojis! ${Emojis.transport_police_car} ${Emojis.animals_dog} ${Emojis.flag_UnitedStates} ${Emojis.person_baby}',
      ),
    );
  }

// WAKE UP NOTIFICATION
  static Future<void> createWakeUpNotification(int id) async {
    await Future.delayed(const Duration(seconds: 5));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: "basic_channel",
        title: "Hey wake up",
        body: "Wake up you lazy bastard",
        wakeUpScreen: true,
      ),
    );
  }

  // Live Score Notification

  static Future<void> createLiveScoreNotification(
      {required int id, required String title, required String body, String? largeIcon}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: "basic_channel",
        title: title,
        body: body,
        // locked: true,
        largeIcon: largeIcon,
      ),
    );
  }

  static cancelScheduleNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  // Event Listener

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    bool isSilentAction = receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction;

    debugPrint("${isSilentAction ? 'silent action' : 'Action'} notification recevied");

    print("recivedAction : ${receivedAction.toString()}");

    if (receivedAction.channelKey == "chats") {
      receiveChatNotificationAction(receivedAction);
    }

    Fluttertoast.showToast(
      msg: '${isSilentAction ? 'silent action' : 'Action'}  notification recevied',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> receiveChatNotificationAction(ReceivedAction receivedAction) async {
    // print("recevied Action : ${receivedAction.toString()}");
    if (receivedAction.buttonKeyPressed == 'REPLY') {
      await createMessagingNotification(
        channelKey: 'chats',
        groupKey: receivedAction.groupKey!,
        chatName: receivedAction.summary!,
        username: 'you',
        largeIcon:
            "https://images.unsplash.com/photo-1619895862022-09114b41f16f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
        message: receivedAction.buttonKeyInput,
      );
    } else {
      // navigate to the user chat page via routing
      // router parmerter be like => /chat/{nayan}
    }
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedAction) async {
    debugPrint("Notification created");

    Fluttertoast.showToast(
      msg: 'Notification created ',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedAction) async {
    debugPrint("Notification displayed");

    Fluttertoast.showToast(
      msg: 'Notification displayed ',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("Notification dismiss");

    Fluttertoast.showToast(
      msg: 'Notification dismiss ',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
