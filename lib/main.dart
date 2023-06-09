import 'package:flutter/material.dart';
import 'package:flutter_notification/app/services/local_notification_service.dart';
import 'package:flutter_notification/app/services/remote_notification_service.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*await LocalNotificationService.initializeLocalNotifications(debug: true);

  await RemoteNotificationService.initializeRemoteNotifications(debug: true);*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
