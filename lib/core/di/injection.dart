// Package imports:
import 'package:flutter_notification/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
// Project imports:

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, //// default
  asExtension: false, // default
)
Future<void> configureDependencies(String env) async => $initGetIt(getIt, environment: env);
