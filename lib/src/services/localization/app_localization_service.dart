import 'translations.dart';

class AppLocalizationService {
  String _language = 'en';

  String translate(String key) {
    final languageTranslation = translations[_language] ?? {};
    if (languageTranslation.isEmpty || !languageTranslation.containsKey(key)) {
      return key;
    }
    return languageTranslation[key]!;
  }

  void setLanguage(String language) {
    _language = language;
  }
}
