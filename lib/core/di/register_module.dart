// Flutter imports:

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


@module
abstract class RegisterModule {
  // url here will be injected
  @lazySingleton
  Dio dio() {
    final dio = Dio();
    dio.options.headers.putIfAbsent('Content-Type', () => 'application/json; charset=utf-8');
    dio.options.headers.putIfAbsent('Accept', () => 'application/json; charset=utf-8');
    return dio;
  }
}
