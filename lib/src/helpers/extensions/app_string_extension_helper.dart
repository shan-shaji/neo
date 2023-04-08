import 'package:neo/src/app/locator.dart';
import 'package:neo/src/services/localization/app_localization_service.dart';

extension AppStringExtension on String {
  static final appLocal = locator<AppLocalizationService>();

  // Transaltes the string  based on localization configuration
  String get tr {
    return appLocal.translate(this);
  }
}
