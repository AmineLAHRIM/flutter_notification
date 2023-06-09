import 'package:flutter/material.dart';
import 'package:flutter_notification/core/di/injection.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final controller = Get.put(getIt<HomeController>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () => controller.onPush(),
                child: const Text(
                  'Push Notification',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
                onPressed: () => controller.onSchedulePush(),
                child: const Text(
                  'Schedule Push Notification after 5 sec',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
                onPressed: () => controller.onSubscribeToTopic('anime'),
                child: const Text(
                  'Subscribe to anime',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
