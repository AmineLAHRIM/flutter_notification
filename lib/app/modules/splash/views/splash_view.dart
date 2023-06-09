import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/di/injection.dart';
import 'package:flutter_notification/firebase_options.dart';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies(Environment.prod);
    //await _initHive();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    //controller init
    Get.put(getIt<SplashController>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SplashView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
