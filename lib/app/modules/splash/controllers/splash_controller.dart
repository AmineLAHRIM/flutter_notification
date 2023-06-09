import 'package:flutter/cupertino.dart';
import 'package:flutter_notification/app/routes/app_pages.dart';
import 'package:flutter_notification/app/services/local_notification_service.dart';
import 'package:flutter_notification/app/services/remote_notification_service.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

@injectable
class SplashController extends GetxController {
  final LocalNotificationService localNotificationService;
  final RemoteNotificationService remoteNotificationService;


  SplashController(this.localNotificationService, this.remoteNotificationService);

  @override
  void onInit() async {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
// local notification initialization
    await LocalNotificationService.initializeLocalNotifications(debug: true);

    await RemoteNotificationService.initializeRemoteNotifications(debug: true);
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
