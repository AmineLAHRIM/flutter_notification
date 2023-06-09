// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../app/modules/home/controllers/home_controller.dart' as _i7;
import '../../app/modules/splash/controllers/splash_controller.dart' as _i6;
import '../../app/services/local_notification_service.dart' as _i4;
import '../../app/services/remote_notification_service.dart' as _i5;
import 'register_module.dart' as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.Dio>(() => registerModule.dio());
  gh.lazySingleton<_i4.LocalNotificationService>(
      () => _i4.LocalNotificationService());
  gh.lazySingleton<_i5.RemoteNotificationService>(
      () => _i5.RemoteNotificationService(get<_i3.Dio>()));
  gh.factory<_i6.SplashController>(() => _i6.SplashController(
        get<_i4.LocalNotificationService>(),
        get<_i5.RemoteNotificationService>(),
      ));
  gh.factory<_i7.HomeController>(() => _i7.HomeController(
        get<_i5.RemoteNotificationService>(),
        get<_i4.LocalNotificationService>(),
      ));
  return get;
}

class _$RegisterModule extends _i8.RegisterModule {}
