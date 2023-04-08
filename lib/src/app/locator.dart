import 'package:get_it/get_it.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/services/app_services.dart';
import 'package:neo/src/services/localization/app_localization_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton<AppHiveDbService>(AppHiveDbService.new)
    ..registerLazySingleton<AppHiveDBCommandsService>(
      AppHiveDBCommandsService.new,
    )
    ..registerLazySingleton<Logger>(Logger.new)
    ..registerLazySingleton<AppLocalizationService>(AppLocalizationService.new);
}
