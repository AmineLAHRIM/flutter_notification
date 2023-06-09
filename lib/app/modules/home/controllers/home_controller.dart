import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_notification/app/services/local_notification_service.dart';
import 'package:flutter_notification/app/services/remote_notification_service.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeController extends GetxController {
  final RemoteNotificationService remoteNotificationService;
  final LocalNotificationService localNotificationService;

  HomeController(this.remoteNotificationService, this.localNotificationService);

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initNotificationListener();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  onPush() {
    remoteNotificationService.sendPushMessage();
  }

  onSchedulePush() {
    LocalNotificationService.scheduleNotification();
  }

  onSubscribeToTopic(String topic) {
    remoteNotificationService.subscribeToTopic(topic);
  }

  onUnSubcribeToTopic(String topic) {
    remoteNotificationService.unSubcribeToTopic(topic);
  }

  _initNotificationListener() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    LocalNotificationService.initializeNotificationsEventListeners();
  }
}
